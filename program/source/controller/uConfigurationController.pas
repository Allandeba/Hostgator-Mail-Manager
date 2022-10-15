unit uConfigurationController;

interface

uses
  uConfiguration;

type
  TConfigurationController = class
  private
    function GetSessionManagerConfiguration: TSessionManagerConfiguration;
  public
    procedure LoadSessionInformation;
  end;

implementation

uses
  System.Classes, System.SysUtils, uSystemInfo, uSessionManager, uConsts;

{ TConfigurationController }

function TConfigurationController.GetSessionManagerConfiguration: TSessionManagerConfiguration;
var
  ACompanyConfigurationFileName: String;
  ACompanyInformation: TStringList;
begin
  Result := nil;
  ACompanyConfigurationFileName := TSystemInfo.GetFilePathCompanyConfiguration;
  if not FileExists(ACompanyConfigurationFileName) then
    Exit;

  Result := TSessionManagerConfiguration.Create;
  try
    ACompanyInformation := TStringList.Create;
    try
      ACompanyInformation.LoadFromFile(ACompanyConfigurationFileName);
      Result.Domain := ACompanyInformation.Values[SYSTEM_PARAM_DOMAIN];
      Result.MainUsername := ACompanyInformation.Values[SYSTEM_PARAM_MAIN_USERNAME];
    finally
      ACompanyInformation.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure TConfigurationController.LoadSessionInformation;
var
  ASessionManagerConfiguration: TSessionManagerConfiguration;
begin
  ASessionManagerConfiguration := GetSessionManagerConfiguration;
  try
    if ASessionManagerConfiguration = nil then
      Exit;

    TSessionManager.FillSessionManagerConfiguration(ASessionManagerConfiguration);
  finally
    ASessionManagerConfiguration.Free;
  end;
end;

end.
