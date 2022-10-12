unit uSessionManager;

interface

uses
  uSessionInfo, System.Classes;

type
  TSessionManager = class
  private
    class var FSessionInfo: TSessionInfo;

    {$HINTS OFF}
    constructor Create;
    {$HINTS ON}
  public
    class function GetSessionInfo: TSessionInfo;
    class procedure PopularConfiguracaoSessionManager(_AConfigFile: TStringList);
  end;

implementation

uses
  System.SysUtils, uConsts;

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

class procedure TSessionManager.PopularConfiguracaoSessionManager(_AConfigFile: TStringList);
begin
  GetSessionInfo.Domain := _AConfigFile.Values[SYSTEM_PARAM_DOMAIN];
  GetSessionInfo.MainAPIMail := _AConfigFile.Values[SYSTEM_PARAM_MAIN_MAIL];
end;

initialization

finalization
  TSessionManager.FSessionInfo.Free;

end.
