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
  ACompanyInformationParam: TStringList;
begin
  Result := nil;
  ACompanyConfigurationFileName := TSystemInfo.GetFilePathCompanyConfiguration;
  if not FileExists(ACompanyConfigurationFileName) then
    Exit;

  Result := TSessionManagerConfiguration.Create;
  try
    ACompanyInformationParam := TStringList.Create;
    try
      ACompanyInformationParam.LoadFromFile(ACompanyConfigurationFileName);
      Result.Domain := ACompanyInformationParam.Values[SYSTEM_PARAM_DOMAIN];
      Result.MainEmailUsername := ACompanyInformationParam.Values[SYSTEM_PARAM_MAIN_EMAIL_USERNAME];
      Result.HostgatorUsername := ACompanyInformationParam.Values[SYSTEM_PARAM_HOSTGATOR_USERNAME];
      Result.HostgatorHostIP := ACompanyInformationParam.Values[SYSTEM_PARAM_HOSTGATOR_HOST_IP];
    finally
      ACompanyInformationParam.Free;
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
