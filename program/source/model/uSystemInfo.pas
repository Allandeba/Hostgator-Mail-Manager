unit uSystemInfo;

interface

uses
  Generics.Collections, SysUtils, Forms, uConsts, uFrameworkSysInfo;

type
  TSystemInfo = class(TFrameworkSysInfo)
  public
    class function GetFilePathConfigEmpresa: String;
    class function GetFilePathConfig: String;
    class function GetClientVersion<T>: T;
    class function GetAuthorizationToken: String;
  end;

implementation

uses
  System.Classes, JSON, uMessages, uFrameworkMessage, uSessionManager;

{ TSystemInfo }

class function TSystemInfo.GetAuthorizationToken: String;
begin
  Result := Format('cpanel %s:%s', [USER_HOSTGATOR, TSessionManager.GetSessionInfo.Token]);
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

class function TSystemInfo.GetFilePathConfig: String;
begin
  Result := ExtractFilePath(Application.ExeName) + CONFIG_FILE;
end;

class function TSystemInfo.GetFilePathConfigEmpresa: String;
begin
  Result := ExtractFilePath(Application.ExeName) + DOMAIN_FILE;
end;

end.
