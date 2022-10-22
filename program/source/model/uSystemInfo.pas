unit uSystemInfo;

interface

uses
  Generics.Collections, SysUtils, Forms, uConsts, uFrameworkSysInfo;

type
  TSystemInfo = class(TFrameworkSysInfo)
  private
    class function IsBlackTheme: Boolean;
    class function GetDefaultImageFolder: String;
  public
    class function GetFilePathCompanyConfiguration: String;
    class function GetFilePathTokenConfiguration: String;
    class function GetFilePathRetrieveTokenInformationImage: String;
    class function GetFilePathConfigImage: String;
    class function GetFilePathPassword1Image: String;
    class function GetFilePathPassword2Image: String;
    class function GetClientVersion<T>: T;
    class function GetAuthorizationToken: String;
    class function GetURLHostgator: String;
  end;

implementation

uses
  System.Classes, JSON, uMessages, uFrameworkMessage, uSessionManager, Vcl.Themes, uFrameworkConsts;

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

class function TSystemInfo.GetDefaultImageFolder: String;
begin
  if IsBlackTheme then
    Result := ExtractFilePath(Application.ExeName) + IMG_FOLDER + IMG_BLACK_FOLDER
  else
    Result := ExtractFilePath(Application.ExeName) + IMG_FOLDER + IMG_WHITE_FOLDER;
end;

class function TSystemInfo.GetFilePathTokenConfiguration: String;
begin
  Result := ExtractFilePath(Application.ExeName) + CONFIG_FILE;
end;

class function TSystemInfo.GetURLHostgator: String;
begin
  Result := Format('https://%s:2083/cpsess5235788348/execute/Email/', [TSessionManager.GetSessionInfo.HostgatorHostIP]);
end;

class function TSystemInfo.IsBlackTheme: Boolean;
begin
  Result := TStyleManager.ActiveStyle.Name = SYSTEM_THEME;
end;

class function TSystemInfo.GetFilePathCompanyConfiguration: String;
begin
  Result := ExtractFilePath(Application.ExeName) + COMPANY_FILE;
end;

class function TSystemInfo.GetFilePathConfigImage: String;
begin
  Result := GetDefaultImageFolder;
  Result := Result + IMG_SETTINGS;
end;

class function TSystemInfo.GetFilePathPassword1Image: String;
begin
  Result := GetDefaultImageFolder;
  Result := Result + IMG_BUTTON_PASSWORD_1;
end;

class function TSystemInfo.GetFilePathPassword2Image: String;
begin
  Result := GetDefaultImageFolder;
  Result := Result + IMG_BUTTON_PASSWORD_2;
end;

class function TSystemInfo.GetFilePathRetrieveTokenInformationImage: String;
begin
  Result := GetDefaultImageFolder;
  Result := Result + IMG_RETRIEVE_TOKEN_INFORMATION;
end;

end.
