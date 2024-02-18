unit USock;

interface

uses
  Windows, Winsock;

{

���� �� ��������� ������ ����������� � wide TMEMO
(� ��� �������� memo.lines.text)
�� ������� ����������� �� �������.

������������� �� Win98/ME/2K, 95 OSR 2 � NT service
pack #3 , ������ ��� ������������ WinSock 2 (WS2_32.DLL)

}

function EnumInterfaces(var sInt: string): Boolean;

{ ������� WSAIOCtl ������������� �� Winsock 2.0 - Winsock 2 �������� }
{ ������ � Win98/ME/2K � 95 OSR2, NT srv pack #3 }

function WSAIoctl(s: TSocket; cmd: DWORD; lpInBuffer: PCHAR; dwInBufferLen:
  DWORD;
  lpOutBuffer: PCHAR; dwOutBufferLen: DWORD;
  lpdwOutBytesReturned: LPDWORD;
  lpOverLapped: POINTER;
  lpOverLappedRoutine: POINTER): Integer; stdcall; external 'WS2_32.DLL';

{ ��������� ������ �� ��������� C ������ }

const
  SIO_GET_INTERFACE_LIST = $4004747F;
  IFF_UP = $00000001;
  IFF_BROADCAST = $00000002;
  IFF_LOOPBACK = $00000004;
  IFF_POINTTOPOINT = $00000008;
  IFF_MULTICAST = $00000010;

type sockaddr_gen = packed record
  AddressIn: sockaddr_in;
  filler: packed array [0..7] of char;
end;

type INTERFACE_INFO = packed record
  iiFlags: u_long; // ����� ����������
  iiAddress: sockaddr_gen; // ����� ����������
  iiBroadcastAddress: sockaddr_gen; // Broadcast �����
  iiNetmask: sockaddr_gen; // ����� �������
end;

implementation

{-------------------------------------------------------------------

1. ��������� WINSOCK
2. ������ �����
3. �������� WSAIOCtl ��� ������� � ������� �����������
4. ��� ������� ����������, �������� IP, MASK, BROADCAST, ������
5. ��������� ������ �������� CRLF
6. ����� :)

--------------------------------------------------------------------}

function EnumInterfaces(var sInt: string): Boolean;
var
  s: TSocket;
  wsaD: WSADATA;
  NumInterfaces: Integer;
  BytesReturned, SetFlags: u_long;
  pAddrInet: SOCKADDR_IN;
  pAddrString: PCHAR;
  PtrA: pointer;
  Buffer: array[0..20] of INTERFACE_INFO;
  i: Integer;
  ts:string;
begin
  result := true; // �������������� ����������
  sInt := '';

  WSAStartup($0101, wsaD); // ��������� WinSock
  // ����� ����� �������� ��������� ����������� ������ :)

  s := Socket(AF_INET, SOCK_STREAM, 0); // ��������� �����
  if (s = INVALID_SOCKET) then
    exit;

  try // �������� WSAIoCtl
    PtrA := @bytesReturned;
    if (WSAIoCtl(s, SIO_GET_INTERFACE_LIST, nil, 0, @Buffer,
    1024, PtrA, nil, nil) <> SOCKET_ERROR) then
    begin // ���� OK, �� ���������� ���������� ������������ �����������

      NumInterfaces := BytesReturned div SizeOf(INTERFACE_INFO);

      for i := 0 to NumInterfaces - 1 do // ��� ������� ����������
      begin
        ts:='';
        pAddrInet := Buffer[i].iiAddress.addressIn; // IP �����
        pAddrString := inet_ntoa(pAddrInet.sin_addr);
        ts:=pAddrString;
        {
        ts := ts + ' IP=' + pAddrString + ',';
        pAddrInet := Buffer[i].iiNetMask.addressIn; // ����� �������
        pAddrString := inet_ntoa(pAddrInet.sin_addr);
        ts := ts + ' Mask=' + pAddrString + ',';
        pAddrInet := Buffer[i].iiBroadCastAddress.addressIn; // Broadcast �����
        pAddrString := inet_ntoa(pAddrInet.sin_addr);
        ts := ts + ' Broadcast=' + pAddrString + ',';

        SetFlags := Buffer[i].iiFlags;
        if (SetFlags and IFF_UP) = IFF_UP then
          ts := ts + ' Interface UP,' // ������ ���������� up/down
        else
          ts := ts + ' Interface DOWN,';

        if (SetFlags and IFF_BROADCAST) = IFF_BROADCAST then // Broadcasts
          ts := ts + ' Broadcasts supported,' // ������������ ���
        else // �� ��������������
          ts := ts + ' Broadcasts NOT supported,';

        if (SetFlags and IFF_LOOPBACK) = IFF_LOOPBACK then // ����������� ���
          ts := ts + ' Loopback interface'
        else
          ts := ts + ' Network interface'; // ����������

        ts := ts + #13#10; // CRLF ����� ������ �����������
        }

        // sInt:=sInt+ts;

        if
        //(pos('192.',ts)<>1)and(pos('127.',ts)<>1)
        1=1
         then
        sInt:=sInt+' '+ts;

      end;
  end;
  except
  end;
  //
  // ��������� ������
  //
  CloseSocket(s);
  WSACleanUp;
  result := false;
end;

end.

