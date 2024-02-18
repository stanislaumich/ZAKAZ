unit TcpTable;
interface
type
  PDWord = ^Longword;
  PMIB_TCPROW = ^TMIB_TCPROW;
  TMIB_TCPROW = record
    dwState: LongWord;
    dwLocalAddr: LongWord;
    dwLocalPort: LongWord;
    dwRemoteAddr: LongWord;
    dwRemotePort: LongWord;
  end;
  PMIB_TCPTABLE = ^TMIB_TCPTABLE;
  TMIB_TCPTABLE = record
    dwNumEntries: LongWord;
    table: array[0..0] of TMIB_TCPROW;
  end;

function GetLocalIP: String;

function GetTcpTable(var TcpTable: PMIB_TCPTABLE;
  var Size: PDWord; bOrder: Boolean): LongWord; stdcall

implementation
uses winsock;



function GetLocalIP: String;
const WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
begin
  Result := '';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
    end;
    WSACleanup;
  end;
end;





function GetTcpTable; external 'Iphlpapi.dll' name 'GetTcpTable';

end.
