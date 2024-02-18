unit USock;

interface

uses
  Windows, Winsock;

{

Если Вы поместите строку результатов в wide TMEMO
(в его свойство memo.lines.text)
то никаких результатов не увидите.

Тестировалось на Win98/ME/2K, 95 OSR 2 и NT service
pack #3 , потому что используется WinSock 2 (WS2_32.DLL)

}

function EnumInterfaces(var sInt: string): Boolean;

{ функция WSAIOCtl импортируется из Winsock 2.0 - Winsock 2 доступен }
{ только в Win98/ME/2K и 95 OSR2, NT srv pack #3 }

function WSAIoctl(s: TSocket; cmd: DWORD; lpInBuffer: PCHAR; dwInBufferLen:
  DWORD;
  lpOutBuffer: PCHAR; dwOutBufferLen: DWORD;
  lpdwOutBytesReturned: LPDWORD;
  lpOverLapped: POINTER;
  lpOverLappedRoutine: POINTER): Integer; stdcall; external 'WS2_32.DLL';

{ Константы взятые из заголовка C файлов }

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
  iiFlags: u_long; // Флаги интерфейса
  iiAddress: sockaddr_gen; // Адрес интерфейса
  iiBroadcastAddress: sockaddr_gen; // Broadcast адрес
  iiNetmask: sockaddr_gen; // Маска подсети
end;

implementation

{-------------------------------------------------------------------

1. Открываем WINSOCK
2. Создаём сокет
3. Вызываем WSAIOCtl для доступа к сетевым интерфейсам
4. Для каждого интерфейса, получаем IP, MASK, BROADCAST, статус
5. Разделяем строку символом CRLF
6. Конец :)

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
  result := true; // Инициализируем переменную
  sInt := '';

  WSAStartup($0101, wsaD); // Запускаем WinSock
  // Здесь можно дабавить различные обработчики ошибки :)

  s := Socket(AF_INET, SOCK_STREAM, 0); // Открываем сокет
  if (s = INVALID_SOCKET) then
    exit;

  try // Вызываем WSAIoCtl
    PtrA := @bytesReturned;
    if (WSAIoCtl(s, SIO_GET_INTERFACE_LIST, nil, 0, @Buffer,
    1024, PtrA, nil, nil) <> SOCKET_ERROR) then
    begin // Если OK, то определяем количество существующих интерфейсов

      NumInterfaces := BytesReturned div SizeOf(INTERFACE_INFO);

      for i := 0 to NumInterfaces - 1 do // Для каждого интерфейса
      begin
        ts:='';
        pAddrInet := Buffer[i].iiAddress.addressIn; // IP адрес
        pAddrString := inet_ntoa(pAddrInet.sin_addr);
        ts:=pAddrString;
        {
        ts := ts + ' IP=' + pAddrString + ',';
        pAddrInet := Buffer[i].iiNetMask.addressIn; // Маска подсети
        pAddrString := inet_ntoa(pAddrInet.sin_addr);
        ts := ts + ' Mask=' + pAddrString + ',';
        pAddrInet := Buffer[i].iiBroadCastAddress.addressIn; // Broadcast адрес
        pAddrString := inet_ntoa(pAddrInet.sin_addr);
        ts := ts + ' Broadcast=' + pAddrString + ',';

        SetFlags := Buffer[i].iiFlags;
        if (SetFlags and IFF_UP) = IFF_UP then
          ts := ts + ' Interface UP,' // Статус интерфейса up/down
        else
          ts := ts + ' Interface DOWN,';

        if (SetFlags and IFF_BROADCAST) = IFF_BROADCAST then // Broadcasts
          ts := ts + ' Broadcasts supported,' // поддерживает или
        else // не поддерживается
          ts := ts + ' Broadcasts NOT supported,';

        if (SetFlags and IFF_LOOPBACK) = IFF_LOOPBACK then // Циклический или
          ts := ts + ' Loopback interface'
        else
          ts := ts + ' Network interface'; // нормальный

        ts := ts + #13#10; // CRLF между каждым интерфейсом
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
  // Закрываем сокеты
  //
  CloseSocket(s);
  WSACleanUp;
  result := false;
end;

end.

