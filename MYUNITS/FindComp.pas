unit FindComp;

interface

uses
  Windows, Classes;

function FindComputers: DWORD;

var
  Computers: TStringList;

implementation

uses
  SysUtils;

const
  MaxEntries = 250;

function FindComputers: DWORD;

var
  EnumWorkGroupHandle, EnumComputerHandle: THandle;
  EnumError: DWORD;
  Network: TNetResource;
  WorkGroupEntries, ComputerEntries: DWORD;
  EnumWorkGroupBuffer, EnumComputerBuffer: array[1..MaxEntries] of TNetResource;
  EnumBufferLength: DWORD;
  I, J: DWORD;

begin

  Computers.Clear;

  FillChar(Network, SizeOf(Network), 0);
  with Network do
  begin
    dwScope := RESOURCE_GLOBALNET;
    dwType := RESOURCETYPE_ANY;
    dwUsage := RESOURCEUSAGE_CONTAINER;
  end;

  EnumError := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_ANY, 0, @Network,
    EnumWorkGroupHandle);

  if EnumError = NO_ERROR then
  begin
    WorkGroupEntries := MaxEntries;
    EnumBufferLength := SizeOf(EnumWorkGroupBuffer);
    EnumError := WNetEnumResource(EnumWorkGroupHandle, WorkGroupEntries,
      @EnumWorkGroupBuffer, EnumBufferLength);

    if EnumError = NO_ERROR then
    begin
      for I := 1 to WorkGroupEntries do
      begin
        EnumError := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_ANY, 0,
          @EnumWorkGroupBuffer[I], EnumComputerHandle);
        if EnumError = NO_ERROR then
        begin
          ComputerEntries := MaxEntries;
          EnumBufferLength := SizeOf(EnumComputerBuffer);
          EnumError := WNetEnumResource(EnumComputerHandle, ComputerEntries,
            @EnumComputerBuffer, EnumBufferLength);
          if EnumError = NO_ERROR then
            for J := 1 to ComputerEntries do
              Computers.Add(Copy(EnumComputerBuffer[J].lpRemoteName, 3,
                Length(EnumComputerBuffer[J].lpRemoteName) - 2));
          WNetCloseEnum(EnumComputerHandle);
        end;
      end;
    end;
    WNetCloseEnum(EnumWorkGroupHandle);
  end;

  if EnumError = ERROR_NO_MORE_ITEMS then
    EnumError := NO_ERROR;
  Result := EnumError;

end;

initialization

  Computers := TStringList.Create;

finalization

  Computers.Free;

end.

