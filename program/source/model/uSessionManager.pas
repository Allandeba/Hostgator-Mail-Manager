unit uSessionManager;

interface

uses
  uSessionInfo, uConfiguration;

type
  TSessionManager = class
  private
    class var FSessionInfo: TSessionInfo;

    {$HINTS OFF}
    constructor Create;
    {$HINTS ON}
  public
    class function GetSessionInfo: TSessionInfo;
    class procedure FillSessionManagerConfiguration(_SeessionManagerConfiguration: TSessionManagerConfiguration);
  end;

implementation

uses
  System.SysUtils;

{ TSessionManager }

constructor TSessionManager.Create;
begin
  raise Exception.Create('You must use GetSessionInfo to return a instance.');
end;

class function TSessionManager.GetSessionInfo: TSessionInfo;
begin
  if FSessionInfo = nil then
    FSessionInfo := TSessionInfo.Create;
  Result := FSessionInfo;
end;

class procedure TSessionManager.FillSessionManagerConfiguration(_SeessionManagerConfiguration: TSessionManagerConfiguration);
begin
  GetSessionInfo.Domain := _SeessionManagerConfiguration.Domain;
  GetSessionInfo.MainEmailUsername := _SeessionManagerConfiguration.MainEmailUsername;
  GetSessionInfo.HostgatorUsername := _SeessionManagerConfiguration.HostgatorUsername;
  GetSessionInfo.HostgatorHostIP := _SeessionManagerConfiguration.HostgatorHostIP;
end;

initialization

finalization
  TSessionManager.FSessionInfo.Free;

end.
