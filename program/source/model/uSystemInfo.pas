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
    class function GetClientVersion: String;
    class function GetAuthorizationToken(_HostgatorUsername: String; _Token: String): String;
    class function GetURLHostgator(_HostgatorHostIP: String): String;
    class function GetAPIUsername: String;
  end;

implementation

uses
  System.Classes, JSON, uMessages, uFrameworkMessage, Vcl.Themes, uFrameworkConsts;

{ TSystemInfo }

class function TSystemInfo.GetAPIUsername: String;
var
  AStringList: TStringList;
begin
  if not FileExists(COMPANY_FILE) then
    TMessageView.New(MSG_0012).Detail(COMPANY_FILE).ShowAndAbort;

  AStringList := TStringList.Create;
  try
    AStringList.LoadFromFile(COMPANY_FILE);
    Result := AStringList.Values[SYSTEM_PARAM_MAIN_EMAIL_USERNAME];
  finally
    AStringList.Free;
  end;
end;

class function TSystemInfo.GetAuthorizationToken(_HostgatorUsername: String; _Token: String): String;
begin
  Result := Format('cpanel %s:%s', [_HostgatorUsername, _Token]);
end;

class function TSystemInfo.GetClientVersion: String;
var
  AStringList: TStringList;
begin
  if not FileExists(VERSION_PATH) then
    TMessageView.New(MSG_0012).Detail(VERSION_PATH).ShowAndAbort;

  AStringList := TStringList.Create;
  try
    AStringList.LoadFromFile(VERSION_PATH);
    Result := AStringList.Values[VERSION_PARAM];
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

class function TSystemInfo.GetURLHostgator(_HostgatorHostIP: String): String;
begin
  Result := 'https://' + _HostgatorHostIP + ':2083/cpsess5235788348/execute/Email/';
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
