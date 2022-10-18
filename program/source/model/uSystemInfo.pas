unit uSystemInfo;

interface

uses
  Generics.Collections, SysUtils, Forms, uConsts, uFrameworkSysInfo;

type
  TSystemInfo = class(TFrameworkSysInfo)
  public
    class function GetFilePathCompanyConfiguration: String;
    class function GetFilePathTokenConfiguration: String;
    class function GetFilePathRetrieveTokenInformationImage: String;
    class function GetClientVersion<T>: T;
    class function GetAuthorizationToken: String;
    class function GetURLHostgator: String;
  end;

implementation

uses
  System.Classes, JSON, uMessages, uFrameworkMessage, uSessionManager;

{ TSystemInfo }

class function TSystemInfo.GetAuthorizationToken: String;
begin
  Result := Format('cpanel %s:%s', [TSessionManager.GetSessionInfo.HostgatorUsername, TSessionManager.GetSessionInfo.Token]);
end;

class function TSystemInfo.GetClientVersion<T>: T;
var
  AStringList: TStringList;
  AJSONValue: TJSonValue;
begin
  if not FileExists(VERSION_PATH) then
    TMessageView.New(MSG_0012).Detail(VERSION_PATH).ShowAndAbort;

  AStringList := TStringList.Create;
  try
    AStringList.LoadFromFile(VERSION_PATH);
    AJSONValue := TJSonObject.ParseJSONValue(AStringList.Text);
    try
      Result := AJSONValue.GetValue<T>('version');
    finally
      AJSONValue.Free;
    end;
  finally
    AStringList.Free;
  end;
end;

class function TSystemInfo.GetFilePathTokenConfiguration: String;
begin
  Result := ExtractFilePath(Application.ExeName) + CONFIG_FILE;
end;

class function TSystemInfo.GetURLHostgator: String;
begin
  Result := Format('https://%s:2083/cpsess5235788348/execute/Email/', [TSessionManager.GetSessionInfo.HostgatorHostIP]);
end;

class function TSystemInfo.GetFilePathCompanyConfiguration: String;
begin
  Result := ExtractFilePath(Application.ExeName) + COMPANY_FILE;
end;

class function TSystemInfo.GetFilePathRetrieveTokenInformationImage: String;
begin
  Result := ExtractFilePath(Application.ExeName) + IMG_RETRIEVE_TOKEN_INFORMATION;
end;

end.
