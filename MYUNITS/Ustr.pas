unit Ustr;
interface
 uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, //DBTables,
  comctrls, ShellAPI, ShlObj,grids;
  //,  SQLiteTable3;

//==============================================================================
 const
  cpWin = 01;
  cpAlt = 02;
  cpKoi = 03;
  AltSet = ['А'..'Я', 'а'..'п', 'р'..'я'];
  KoiSet = ['Б'..'Р', 'Т'..'С'];
  WinSet = ['а'..'п', 'р'..#255];



 type
  ArrOfStr = array of string;

  MyRec=record
   serkod:integer;
   summa:real;
  end;
  A=array[byte] of MyRec;
 var
  MaskString:string;
  dates : array [1..12] of integer=(31,28,31,30,31,30,31,31,30,31,30,31);

 lat:array[1..26] of char =('A','B','C','D','E','F','G','H','I','J','K','L','M',
                          'N','O','P','Q','R','S','T','U','V','W','X','Y','Z');
 rus:array[1..26] of char =('А','В','С','D','Е','F','G','Н','I','J','К','L','М',
                          'N','О','Р','Q','R','S','Т','U','V','W','Х','Y','Z');
 russet: set of char = ['А','В','С','Е','Н','К','М','О','Р','Т','Х'];

 Bufsize: longint;

 tsql:string;
//==============================================================================
procedure Progress2status(p:tprogressbar; s:tstatusbar);

//======== SQLite3
//procedure fillstringgrid(sldb:TSQLiteDatabase; stringgrid1:tstringgrid; ssql:string; f:integer);
//procedure fillcombobox  (sldb:TSQLiteDatabase; combobox1:tcombobox; ssql:string);
//function  savestringgrid(sldb:TSQLiteDatabase; stringgrid : tstringgrid; tbname:string):string;
//function instringrec(sldb:TSQLiteDatabase; stringgrid : tstringgrid; tbname:string; n:longint):integer;
//function createstringgridtable(sldb:tsqlitedatabase; stringgrid : tstringgrid; tbname:string):string;


//======== SQLite3

function parsehome(hin:string;var h_num,h_let,h_drob,h_korp:string):boolean;
function parseflat(fin:string;var f_num:string; var f_let:string):boolean;
procedure address(s:string;var street:string;var home:string; var flat:string);


function explode(sPart, sInput: string): ArrOfStr;
function implode(sPart: string; arrInp: ArrOfStr): string;
procedure sort(arrInp: ArrOfStr);
procedure rsort(arrInp: ArrOfStr);

// str - исходная строка
// str1 - подстрока, подлежащая замене
// str2 - заменяющая строка
function nvl(s:string):string;
function StrReplace(const Str, Str1, Str2: string): string;
function pnext(del:string; var s:string):string;
function pnexte(del:string; var s:string):string;
Function lTrim(var s:string):string;
Function Trims(s:string):string;
Function Count_pos(s:string):integer;
function Mypos(s:string;d:string; p:integer):string;
function MyposReplace(sin:string;d:string;p:integer;sub:string):string;

function DetermineCodepage(const st: string): Byte;
function DosToWin(St: string): string;
function WinToDos(St: string): string;

function CreateDirEx(Dir: string): Boolean;
Procedure ListFileDir(Path: string; FileList: TStrings;mask:string);



function GetDate(f:char;dt:tdatetime):string;
Function parsedatetimeget(s:string; d:tdatetime):string;
Function parsedatetime(s:string):string;
Function ParseOracleDate(s:string):string;
Function ParseMySQLDate(s:string):string;
function ConvertBankDateToDate(s:string):string;
//function ConvertDateToBankDate(s:string):string;
function strmonth(d:tdatetime;caps:boolean):string;
function invalid(s:string):boolean;
function validatedate(s:string):boolean;
function testnum(s:string):boolean;

procedure nop;
procedure pause(t:int64);

function CopyFile(FromPath, ToPath: string): integer;
function CopyFileProgress(FromPath, ToPath: string; p:tprogressbar): integer;
Function FileMove(fs1,fs2:string; del:integer):integer;
procedure StartProg(handle:thandle;prog,param:string);
procedure StartCMD(handle:thandle;param:string);
function ExecAndWait(aCmd: string; WaitTimeOut: cardinal = INFINITE): Cardinal;
procedure Copyfilewin(handle:thandle;from,tof:string);
function FExist(s:string):boolean;
Function OpenFolder(form1:tform):string;
function Getfiles(Memo1: TMemo; ext:string):boolean;

function procent(org:double; pr:double):double;
function percent(a,b:double):double;
//Function proportional(summa:string; summap:string; q1:tquery; q2:tquery):A;
//==============================================================================
implementation
//uses Unit1;

function nvl(s:string):string;
begin
 Result:=s;
 if s='' then result:=' ';
end;

// ==========================  DB SQLite 3  ========================



{procedure fillstringgrid(sldb:TSQLiteDatabase; stringgrid1:tstringgrid; ssql:string;f:integer);
var
 i,j:cardinal;
 sltb:TSQLIteTable;
begin
 sltb:=sldb.gettable(ssql);
 // ============ do not likes empty table
 if sltb.Count=0 then exit;
 // ======================================
 stringgrid1.ColCount:=sltb.ColCount;
 stringgrid1.RowCount:=sltb.RowCount+1;
 stringgrid1.repaint;
 // fill headers
 if f=1 then
 for i:=0 to sltb.colcount-1 do
  begin
   stringgrid1.Cells[i,0]:='('+inttostr(i)+')-';
   stringgrid1.Cells[i,0]:=stringgrid1.Cells[i,0] + utf8decode(sltb.columns[i]);
  end;
 // -- END -- fill headers
 j:=0;
 while not sltb.EOF do
  begin
   for i:=0 to sltb.colcount-1 do
    begin
     stringgrid1.Cells[i,j+1]:=utf8decode(sltb.FieldAsString(i));
    end;
   sltb.Next;
   inc(j);
  end;
 stringgrid1.repaint;
 sltb.Free;
end;

procedure fillcombobox(sldb:TSQLiteDatabase; combobox1:tcombobox; ssql:string);
var
 sltb:tsqlitetable;
begin
 sltb:=sldb.gettable(ssql);
 while not sltb.EOF do
  begin
   combobox1.items.add(utf8decode(sltb.FieldAsString(0)));
   sltb.Next;
  end;
 combobox1.text:='';
 sltb.Free;
end;

function instringrec(sldb:TSQLiteDatabase; stringgrid : tstringgrid; tbname:string; n:longint):integer;
// insert record in table from position
var
 i:longint;
 s:string;
 begin
  tsql:='insert into '+tbname+' (';
  for i:=0 to stringgrid.ColCount-1 do
   begin
    s:=stringgrid.Cells[i,0];
    delete(s,1,pos('-',s));
    s:=utf8encode(s);
    if i= stringgrid.ColCount-1 then
     tsql:=tsql+s+') values ("'
     else tsql:=tsql+S+', ';
   end;
  for i:=0 to stringgrid.ColCount-1 do
   begin
    s:=stringgrid.Cells[i,n];
    s:=utf8encode(s);
    if i= stringgrid.ColCount-1 then
     tsql:=tsql+s+'");'
     else tsql:=tsql+s+'", "';
   end;
  sldb.ExecSQL(tsql);
  instringrec:=0;
 end;


function savestringgrid(sldb:TSQLiteDatabase; stringgrid : tstringgrid; tbname:string):string;
var
 i:longint;
// s:string;
 begin
  sldb.BeginTransaction;
  tsql:='drop table if exists '+tbname+'_old;';
  sldb.ExecSQL(tsql);
  tsql:='alter table '+tbname+' rename to '+ tbname+'_old;';
  sldb.ExecSQL(tsql);
  createstringgridtable(sldb,stringgrid,'worker');
  //
  for i:=1 to stringgrid.RowCount-1 do
   instringrec(sldb,stringgrid,tbname,i);
  //
  // drop database
  tsql:='drop table if exists '+ tbname+'_old;';
  sldb.ExecSQL(tsql);

  sldb.Commit;
 end;

function createstringgridtable(sldb:tsqlitedatabase; stringgrid : tstringgrid; tbname:string):string;
var
 i:integer;
 s:string;
 //sldb: tsqlitedatabase;
 begin
  //sldb.BeginTransaction;
  tsql:='create table '+tbname +'(id integer primary key ,';
  for i:=1 to stringgrid.ColCount-1 do
   begin
    s:=stringgrid.Cells[i,0];
    delete(s,1,pos('-',s));
    if i= stringgrid.ColCount-1 then
     tsql:=tsql+s+' varchar(255)'
     else tsql:=tsql+s+' varchar(255), ';
   end;
   tsql:=tsql+');';
   sldb.ExecSQL(tsql);
   //sldb.Commit;
 end;
 }
// ========================
function getdate(f:char;dt:tdatetime):string;
var
 s:string;
begin
 s:=datetostr(dt);
 case f of
  'd','D':begin
           delete(s,3,length(s));
          end;
   'm','M':begin
            delete(s,1,3);
            delete(s,3,length(s));
           end;
   'y','Y':begin
            delete(s,1,6);
           end;

 end;// case
  getdate:=s;
end;

function Getfiles(Memo1: TMemo; ext:string):boolean;
var
 tgd:TOpenDialog;
 res: boolean;
begin
 tgd:=TOpendialog.Create(memo1);
 if ext<>'' then tgd.Filter:=ext;
 tgd.Options:=[ofHideReadOnly,ofAllowMultiSelect,ofEnableSizing];
 res:= tgd.execute;
 if res then
  begin
   memo1.Lines:=tgd.Files;
  end;
  tgd.Free;
  GetFiles:=res;
end;



function testnum(s:string):boolean;
var
 r:double;
begin
 result:=true;
 try
  r:=0+strtofloat(s);
 except

  on EConvertError do begin
   result:=false;
    exit;
    end;

 end;
 r:=r+0;
end;



function validatedate(s:string):boolean;
var
 day,month,year:integer;
 begin
  Result:=true;
  dates[2]:=28;
  day:=strtoint(pnext('.',s));
  month:=strtoint(pnext('.',s));
  year:=strtoint(s);
  if (day<1) or(month<1) or (year<1) then
   begin
    result:=false;
    exit;
   end; 
  if (year mod 4 = 0) then dates[2]:=29;
  if day>dates[month] then result:=false;
 end;


{/*Function proportional(summa:string; summap:string; q1:tquery; q2:tquery):A;
var
 i:byte;
 m:A;
 s:real;
 begin
  //Q1.Open;
  //Q2.Open;
  Q2.First;
  m[0].serkod:=0;
  s:=0;
  while not Q2.Eof do
   begin
    inc(m[0].serkod);
    m[m[0].serkod].serkod:=Q2.FieldByName('serkod').AsInteger;
    m[m[0].serkod].summa:=round(Q2.FieldByName('summa').AsFloat/Q1.fieldByName('summa').AsFloat*strtofloat(summa));
    m[m[0].serkod].summa:=m[m[0].serkod].summa*(-1);
    s:=s-m[m[0].serkod].summa;
    Q2.Next;
   end;
  Q2.First;
  if summap<>'0' then
  m[1].summa:=m[1].summa-strtofloat(summap);
  m[1].summa:=round(m[1].summa-strtofloat(summa)+s);
  m[0].summa:=s;
  proportional:=m;
  //Q1.Close;
  //Q2.Close;
 end;
*/ }

function parseflat(fin:string; var f_num:string; var f_let:string):boolean;
var
 i:integer;
 s:string;
 res:boolean;
 cod:integer;
 c:char;
 begin
  parseflat:=false;
  //
  //for i:=1 to length(fin) do
  // if (fin[i] <'1') or (fin[i]>'0') then
  //  res:=true;
  //
  val(fin,i,cod);
  if cod<>0 then
   begin
    f_num:=copy(fin,1,cod-1);
    f_let:=copy(fin,cod,10);
    c:=f_let[1];
    f_let:=inttostr(ord(c)-ord('А')+1);
    res:=true;
   end
  else
   begin
    f_num:=fin;
    f_let:='0';
    res:=false;
   end;
  parseflat:=res;  
 end;

function parsehome(hin:string;var h_num, h_let, h_drob,h_korp:string):boolean;
var
 s,ss,sss,ssss:string;
 cod,i:integer;
 begin
  val(hin,i,cod);
  if cod=0 then
   begin
    h_num:=hin;
    h_let:='0';
    h_korp:='0';
    h_drob:='0';
    parsehome:=false;
   end
  else
   begin//тут мы если буква или дробь
    if pos('/',hin)<>0 then//есть дробь
     begin
      s:=copy(hin,1,pos('/',hin)-1);
      ss:=copy(hin,pos('/',hin)+1,10);
      parseflat(s,h_num,h_let);
      h_drob:=ss;
      h_korp:='0';
      parsehome:=true;
     end
    else
     begin // может быть буква
      parseflat(hin,h_num,h_let);
      h_drob:='0';
      h_Korp:='0';
      parsehome:=true;
     end;
    parsehome:=true;
   end;
 end;



Function Count_pos(s:string):integer;
var
 i,j:integer;
 begin
  j:=0;
  for i:=1 to length(s) do
   if s[i]='|' then inc(j);
  Count_pos:=j;
 end;


Function OpenFolder(form1:tform):string;
 var
  TitleName : string;
  lpItemID : PItemIDList;
  BrowseInfo : TBrowseInfo;
  DisplayName : array[0..MAX_PATH] of char;
  TempPath : array[0..MAX_PATH] of char;
begin
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
  BrowseInfo.hwndOwner := Form1.Handle;
  BrowseInfo.pszDisplayName := @DisplayName;
  TitleName := 'Выберите папку резервной копии';
  BrowseInfo.lpszTitle := PChar(TitleName);
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
  lpItemID := SHBrowseForFolder(BrowseInfo);
  if lpItemId <> nil then
  begin
    SHGetPathFromIDList(lpItemID, TempPath);
    //ShowMessage(TempPath);
    GlobalFreePtr(lpItemID);
  end;
 OpenFolder:=TempPath;
end;




function percent(a,b:double):double;
 begin
  percent:=a/b;
 end;

function invalid(s:string):boolean;
var
 ts,rs:string;
 //y,m,d:word;
 cod:integer;
 p:word;
begin
 invalid:=false;
 //try
 ts:=pnext('.',s);
 val(ts,p,cod);
 if cod<>0 then
  begin
   invalid:=true;
   exit;
  end;
 if (strtoint(ts)<1) or (strtoint(ts)>31) then
  Invalid:=true;
 rs:=pnext('.',s);
 val(rs,p,cod);
 if cod<>0 then
  begin
   invalid:=true;
   exit;
  end;
 if (strtoint(rs)<1) or (strtoint(rs)>12) then
  Invalid:=true;
 val(s,p,cod);
 if cod<>0 then
  begin
   invalid:=true;
   exit;
  end;
 if (strtoint(s)<1900) or (strtoint(s)>2050) then
  Invalid:=true;
end;

function procent(org:double; pr:double):double;
var
 r:double;
begin
 procent:=org/100*pr;
end;

function FExist(s:string):boolean;
var
 f:file;
begin
 {$i-}
 Assignfile(f,s);
 Reset(f);
 fexist:=IoResult=0;
 {$i+}
end;

Function LTrim(var s:string):string;
 begin
  if s[1]<>' ' then
   begin

   end
  else
   while s[1]=' ' do delete(s,1,1);
  ltrim:=s;
 end;

procedure Copyfilewin(handle:thandle;from,tof:string);
var
  OpStruc: TSHFileOpStruct;
  frombuf, tobuf: array [0..1024] of Char;
begin
  FillChar( frombuf, Sizeof(frombuf), 0 );
  FillChar( tobuf, Sizeof(tobuf), 0 );
  StrPCopy( frombuf, from);
  StrPCopy( tobuf, tof );
  with OpStruc do
  begin
    Wnd:= Handle;
    wFunc:= FO_COPY;
    pFrom:= @frombuf;
    pTo:=@tobuf;
    fFlags:= FOF_NOCONFIRMATION or FOF_RENAMEONCOLLISION;
    fAnyOperationsAborted:= False;
    hNameMappings:= nil;
    lpszProgressTitle:= nil;
  end;
  ShFileOperation( OpStruc );
end;

function ExecAndWait(aCmd: string; WaitTimeOut: cardinal = INFINITE): Cardinal;
var
  si: STARTUPINFO;
  pi: PROCESS_INFORMATION;
  res: BOOL;
  r: cardinal;
begin
  with si do
  begin
    cb := sizeof(si);
    lpReserved := nil;
    lpDesktop := nil;
    lpTitle := PChar('External program "' + aCmd + '"');
    dwFlags := 0;
    cbReserved2 := 0;
    lpReserved2 := nil;
  end;
  res := CreateProcess(nil, PChar(aCmd), nil, nil, FALSE, 0, nil, nil, si, pi);
  if res then
    WaitForSingleObject(pi.hProcess, WaitTimeOut);
  GetExitCodeProcess(pi.hProcess, r);
  result := r;
end;

procedure StartProg(handle:thandle;prog,param:string);
 begin
  ShellExecute(Handle, 'open',
  pchar(prog),
  PCHAR(param),
  nil,
  SW_SHOWNORMAL);
 end;

procedure StartCMD(handle:thandle;param:string);
 begin
  ShellExecute(Handle, 'open',
  pchar('CMD.EXE /C'),
  PCHAR(param),
  nil,
  SW_SHOWNORMAL);
 end;

function strmonth(d:tdatetime;caps:boolean):string;
var
 dm,m,y:word;
 s:string;
 begin
  Decodedate(d,y,m,dm);
  if caps then
   begin
    case m of
     1: s:='ЯНВАРЬ';
     2: s:='ФЕВРАЛЬ';
     3: s:='МАРТ';
     4: s:='АПРЕЛЬ';
     5: s:='МАЙ';
     6: s:='ИЮНЬ';
     7: s:='ИЮЛЬ';
     8: s:='АВГУСТ';
     9: s:='СЕНТЯБРЬ';
    10: s:='ОКТЯБРЬ';
    11: s:='НОЯБРЬ';
    12: s:='ДЕКАБРЬ';
    end;
   end
  else
   begin
    case m of
     1: s:='январь';
     2: s:='февраль';
     3: s:='март';
     4: s:='апрель';
     5: s:='май';
     6: s:='июнь';
     7: s:='июль';
     8: s:='август';
     9: s:='сентябрь';
    10: s:='октябрь';
    11: s:='ноябрь';
    12: s:='декабрь';
    end;
   end;
  strmonth:=s; 
 end;

Procedure Pause(t:int64);
var c:int64;
 begin
  c := GetTickCount;
   repeat
     Application.ProcessMessages
   until GetTickCount - c >= t;
 end;
//--------------------------------------------------------------------------------------------
function CopyFile(FromPath, ToPath: string): integer;
var
  F1: file;
  F2: file;
  NumRead: integer;
  NumWritten: integer;
  Buf: pointer;
  //BufSize: longint;
  Totalbytes: longint;
  TotalRead: longint;
begin
  Result := 0;
  Assignfile(f1, FromPath);
  Assignfile(F2, ToPath);
  reset(F1, 1);
  TotalBytes := Filesize(F1);
  Rewrite(F2, 1);
  //BufSize := 16384;
  GetMem(buf, BufSize);
  TotalRead := 0;
  repeat
    BlockRead(F1, Buf^, BufSize, NumRead);
    inc(TotalRead, NumRead);
    BlockWrite(F2, Buf^, NumRead, NumWritten);
    application.processmessages;
  until (NumRead = 0) or (NumWritten <> NumRead);
  if (NumWritten <> NumRead) then
  begin
    //ошибка
    result := -1;
  end;
  Closefile(f1);
  Closefile(f2);
end;


function CopyFileProgress(FromPath, ToPath: string; p:tprogressbar): integer;
 var
  F1: file;
  F2: file;
  NumRead: integer;
  NumWritten: integer;
  Buf: pointer;
  //BufSize: longint;
  Totalbytes: longint;
  TotalRead: longint;
begin
  Result := 0;
  Assignfile(f1, FromPath);
  Assignfile(F2, ToPath);
  reset(F1, 1);
  TotalBytes := Filesize(F1);
  p.Min:=0;
  p.Max:= Filesize(F1);
  p.Position:=0;
  Rewrite(F2, 1);
  //BufSize := 16384;
  GetMem(buf, BufSize);
  TotalRead := 0;
  repeat
    BlockRead(F1, Buf^, BufSize, NumRead);
    inc(TotalRead, NumRead);
    BlockWrite(F2, Buf^, NumRead, NumWritten);
    p.Position:=p.Position + NumWritten;
    p.Repaint;
    application.processmessages;
  until (NumRead = 0) or (NumWritten <> NumRead);
  if (NumWritten <> NumRead) then
  begin
    //ошибка
    result := -1;
  end;
  Closefile(f1);
  Closefile(f2);
end;

procedure Progress2status(p:tprogressbar; s:tstatusbar);
 begin
  with P do
  begin
    Position:=0;
    Repaint;
    Parent := S;
    //Position := 100;
    Top := 2;
    Left := 0;
    Height := S.Height - Top;
    Width := S.Panels[0].Width - Left;
  end;

 end;

procedure nop;
var
 i:integer;
 begin
  for i:=0 to 1 do
   begin
    ;
   end;
 end;

Function FileMove(fs1,fs2:string; del:integer):integer;
var
 f1,f2:textfile;
 s:string;
 res:integer;
 begin
  res:=-1;
  AssignFile(f1,fs1);
  {$i-}
   Reset(f1);
   If ioresult<>0 then
    begin
     res:=1;// cannot open src
     Exit;
    End
   ELSE
    begin
     AssignFile(f2,fs2);
     Reset(f2);
     If ioresult=0 then
      begin
       res:=2;// cannot create dst - exist
       Exit;
      end
     else
      begin
       Rewrite(f2);
       If ioresult<>0 then
        begin
         res:=3;// cannot create dst - cannot create new one
         Exit;
        end
       else
        begin
         //ReadLn(f1,s);
         While not eof(f1) do
          begin
           ReadLn(f1,s);
           WriteLn(f2,s);
           res:=0;// excellent
          end;
          //WriteLn(f2,s);
        end;
      end;
    End;
  filemove:=res;
  Closefile(f1);
  Closefile(f2);
  If Del=1 then
  deleteFile(fs1);  
 end;

Function ParseOracleDate(s:string):string;
 begin
  s:=strReplace(S,'.01.','.jan.');
  s:=strReplace(S,'.02.','.feb.');
  s:=strReplace(S,'.03.','.mar.');
  s:=strReplace(S,'.04.','.apr.');
  s:=strReplace(S,'.05.','.may.');
  s:=strReplace(S,'.06.','.jun.');
  s:=strReplace(S,'.07.','.jul.');
  s:=strReplace(S,'.08.','.aug.');
  s:=strReplace(S,'.09.','.sep.');
  s:=strReplace(S,'.10.','.oct.');
  s:=strReplace(S,'.11.','.nov.');
  s:=strReplace(S,'.12.','.dec.');
  ParseOracleDate:=s;
 end;

Function Trims(s:string):string;
var
 i:integer;
 begin
  i:=1;
  While i<length(s) do
   begin
    While (s[i]=' ') and (s[i+1]=' ') and (i<length(s)) do
     begin
      delete (s,i+1,1);
     end;
    inc(i);
    If i>=Length(s) then break;
   end;
  Trims:=s; 
 end;

Procedure ListFileDir(Path: string; FileList: TStrings; mask:string);
 var
   SR: TSearchRec;
 begin
   if FindFirst(Path + mask, faAnyFile, SR) = 0 then
   begin
     repeat
       if (SR.Attr <> faDirectory) then
       begin
         FileList.Add(path+SR.Name);
       end;
     until FindNext(SR) <> 0;
     FindClose(SR);
   end;
 end;

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

function DosToWin(St: string): string;
var
  Ch: PAnsiChar;
begin
  Ch := PAnsiChar(StrAlloc(Length(St) + 1));
  OemToAnsi(PAnsiChar(St), Ch);
  Result := Ch;
  StrDispose(Ch)
end;

function WinToDos(St: string): string;
var
  Ch: PAnsiChar;
begin
  Ch := PAnsiChar(StrAlloc(Length(St) + 1));
  AnsiToOem(PAnsiChar(St), Ch);
  Result := Ch;
  StrDispose(Ch)
end;

Function parsedatetime(s:string):string;
 var
  ts:string;
 begin
  ts:=Datetostr(Date);
  delete(ts,pos('.',ts),length(ts));
  s:=strreplace(s,'%D',ts);
  s:=strreplace(s,'%d',inttostr(strtoint(ts)));
  ts:=Datetostr(Date);
  delete(ts,1,pos('.',ts));
  delete(ts,pos('.',ts),length(ts));
  s:=strreplace(s,'%M',ts);
  s:=strreplace(s,'%m',inttostr(strtoint(ts)));
  ts:=Datetostr(Date);
  delete(ts,1,pos('.',ts));
  delete(ts,1,pos('.',ts));
  s:=strreplace(s,'%Y',ts);
  delete(ts,1,2);
  s:=strreplace(s,'%y',ts);
  ts:=TimeToStr(Time);
  delete(ts,pos(':',ts),length(ts));
  s:=strreplace(s,'%h',ts);
  if strtoint(ts) <10 then
   s:=strreplace(s,'%H','0'+inttostr(strtoint(ts)))
  else
   s:=strreplace(s,'%H',inttostr(strtoint(ts)));
  ts:=Timetostr(Time);
  delete(ts,1,pos(':',ts));
  delete(ts,pos(':',ts),length(ts));
  s:=strreplace(s,'%T',ts);
  s:=strreplace(s,'%t',inttostr(strtoint(ts)));
  ts:=Timetostr(Time);
  delete(ts,1,pos(':',ts));
  delete(ts,1,pos(':',ts));
  s:=strreplace(s,'%S',ts);
  s:=strreplace(s,'%s',inttostr(strtoint(ts)));
  parsedatetime:=s;
 end;

Function parsedatetimeget(s:string; d:tdatetime):string;
 var
  ts:string;
 begin
  ts:=Datetostr(D);
  delete(ts,pos('.',ts),length(ts));
  s:=strreplace(s,'%D',ts);
  s:=strreplace(s,'%d',inttostr(strtoint(ts)));
  ts:=Datetostr(D);
  delete(ts,1,pos('.',ts));
  delete(ts,pos('.',ts),length(ts));
  s:=strreplace(s,'%M',ts);
  s:=strreplace(s,'%m',inttostr(strtoint(ts)));
  ts:=Datetostr(D);
  delete(ts,1,pos('.',ts));
  delete(ts,1,pos('.',ts));
  s:=strreplace(s,'%Y',ts);
  delete(ts,1,2);
  s:=strreplace(s,'%y',ts);
  ts:=TimeToStr(D);
  delete(ts,pos(':',ts),length(ts));
  s:=strreplace(s,'%h',ts);
  if strtoint(ts) <10 then
   s:=strreplace(s,'%H','0'+inttostr(strtoint(ts)))
  else
   s:=strreplace(s,'%H',inttostr(strtoint(ts)));
  ts:=Timetostr(D);
  delete(ts,1,pos(':',ts));
  delete(ts,pos(':',ts),length(ts));
  s:=strreplace(s,'%T',ts);
  s:=strreplace(s,'%t',inttostr(strtoint(ts)));
  ts:=Timetostr(D);
  delete(ts,1,pos(':',ts));
  delete(ts,1,pos(':',ts));
  s:=strreplace(s,'%S',ts);
  s:=strreplace(s,'%s',inttostr(strtoint(ts)));
  parsedatetimeget:=s;
 end;

function StrReplace(const Str, Str1, Str2: string): string;
// str - исходная строка
// str1 - подстрока, подлежащая замене
// str2 - заменяющая строка
var
  P, L: Integer;
begin
  Result := str;
  if length(str)<length(str1) then exit;
  if pos(str1,str)=0 then exit;
  L := Length(Str1);
  repeat
    P := Pos(Str1, Result); // ищем подстроку
    if P > 0 then
    begin
      Delete(Result, P, L); // удаляем ее
      Insert(Str2, Result, P); // вставляем новую
     break; 
    end;
  until P = 0;
end;

function pnexte(del:string; var s:string):string;
var
ts:string;
i:integer;
//st:string;
begin
 for i:=length(s) downto 1 do
  begin
   If s[i]=del then
    begin
     ts:=copy(s,i+1,length(s));
     delete(s,i,length(s));
     break;
    end;
  end;
 //st:=ts;
 pnexte:=ts;
end;

function pnext(del:string; var s:string):string;
var
ts:string;
begin
 ts:='';
 If pos(del,s)<>0 then
  begin
   ts:=s;
   delete(s,1,pos(del,s));
   delete(ts,pos(del,ts),length(ts));
  end;
 pnext:=ts;
end;

function explode(sPart, sInput: string): ArrOfStr;
 begin
   setlength(result,0);
   while Pos(sPart, sInput) <> 0 do
    begin
     SetLength(Result, Length(Result) + 1);
     Result[Length(Result) - 1] := Copy(sInput, 0,Pos(sPart, sInput) - 1);
     Delete(sInput, 1,Pos(sPart, sInput));
   end;
   SetLength(Result, Length(Result) + 1);
   Result[Length(Result) - 1] := sInput;
 end;

 function implode(sPart: string; arrInp: ArrOfStr): string;
 var
    i: Integer;
 begin
   if Length(arrInp) <= 1 then Result := arrInp[0]
   else
    begin
     for i := 0 to Length(arrInp) - 2 do Result := Result + arrInp[i] + sPart;
     Result := Result + arrInp[Length(arrInp) - 1];
   end;
 end;

 procedure sort(arrInp: ArrOfStr);
 var
    slTmp: TStringList;
    i: Integer;
 begin
   slTmp := TStringList.Create;
   for i := 0 to Length(arrInp) - 1 do slTmp.Add(arrInp[i]);
   slTmp.Sort;
   for i := 0 to slTmp.Count - 1 do arrInp[i] := slTmp[i];
   slTmp.Free;
 end;

 procedure rsort(arrInp: ArrOfStr);
 var
    slTmp: TStringList;
    i: Integer;
 begin
   slTmp := TStringList.Create;
   for i := 0 to Length(arrInp) - 1 do slTmp.Add(arrInp[i]);
   slTmp.Sort;
   for i := 0 to slTmp.Count - 1 do arrInp[slTmp.Count - 1 - i] := slTmp[i];
   slTmp.Free;
 end;

Function ParseMySQLDate(s:string):string;
var
 ts1,ts2,ts3:string;
 begin
  ts1:=pnext('.',s);
  ts2:=pnext('.',s);
  ts3:=s;
  parseMySqlDate:=ts3+'-'+ts2+'-'+ts1;
 end;

procedure address(s:string; var street:string; var home:string; var flat:string);
var
 s1,s2,s3:string;
 begin
  flat:=pnexte(' ',s);
  home:=pnexte(' ',s);
  street:=s;
 end;

function Mypos(s:string;d:string; p:integer):string;
var
 i:integer;
 rs:string;
 begin
  for i:=1 to p do
   begin
    rs:=pnext(d,s);
   end;
  Mypos:=rs;
 end;

function DetermineCodepage(const st: string): Byte;
var
    WinCount,
    AltCount,
    KoiCount,
    i, rslt: Integer;
begin
  DetermineCodepage := cpAlt;
  WinCount := 0;
  AltCount := 0;
  KoiCount := 0;
  for i := 1 to Length(st) do
  begin
    if st[i] in AltSet then Inc(AltCount);
    if st[i] in WinSet then Inc(WinCount);
    if st[i] in KoiSet then Inc(KoiCount);
  end;
  DetermineCodepage := cpAlt;
  if KoiCount > AltCount then
  begin
    DetermineCodepage := cpKoi;
    if WinCount > KoiCount then DetermineCodepage := cpWin;
  end
  else
  begin
    if WinCount > AltCount then DetermineCodepage := cpWin;
  end;
end;




function ConvertBankDateToDate(s:string):string;
var
 rs,ts:string;
 begin
  rs:=copy(s,7,2)+'.';
  rs:=rs+copy(s,5,2)+'.';
  rs:=rs+copy(s,1,4);
  ConvertBankDateToDate:=rs;
 end;

function MyPosReplace(sin:string;d:string;p:integer;sub:string):string;
var
 s,s1,s2:string;
 i:integer;
begin
 for i:=1 to p-1 do
  begin
   s:=s+pnext(d,sin)+d;
  end;
 pnext(d,sin); 
 s:=s+sub+d+sin;
 myposreplace:=s;

end;


begin
 maskstring:='*.*';
 Bufsize:=32768;
end.

