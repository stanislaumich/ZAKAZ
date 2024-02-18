unit Upack;
interface
//--------------------------------------------------------------------------------------------
  procedure Unpack(arc:string; mask:string; folder:string);
  procedure Pack(arcname,pathmask:string);
//--------------------------------------------------------------------------------------------
implementation

 uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, DB, DBTables, ComCtrls, StdCtrls, Grids, DBGrids, ExtCtrls,shellapi, ustr;
//--------------------------------------------------------------------------------------------
procedure Pack(arcname,pathmask:string);
 var
  handle:thandle;
 begin
  ShellExecute(Handle, 'open',
  'Winrar.exe',
  PCHAR(' A -ir -ep -dh -r "'+arcname+'" "'+pathmask+'"'),
  nil,
  SW_SHOWNORMAL);
 end;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
procedure Unpack(arc:string; mask:string; folder:string);
 var
  handle:thandle;
  s:pchar;
 begin 
  Createdirex(folder);
  INcludeTrailingBackslash(arc);
  INcludeTrailingBackslash(folder);//'+mask+'
  //D:\_PROGRAMMING\_____________________________GSK_PROG\ARCHIVE\BACKUP\TABLES_19.12.2006_12-16-36.DSCR.RAR
  s:=PChar(' X "'+arc{'d:\TABLES_19.12.2006_12-16-36.DSCR.RAR'}+'" '+mask+' "'+folder+'"');
  ShellExecute(Handle, 'open',  'WinRAR.exe',  s,  nil,  SW_SHOWNORMAL);
  //startprog(handle, '"D:\Program Files\WinRAR\WinRAR.exe"' , s)
 end;
//--------------------------------------------------------------------------------------------
end.
