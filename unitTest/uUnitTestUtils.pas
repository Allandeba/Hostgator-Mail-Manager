unit uUnitTestUtils;

interface

uses
  uLogin, uHostgatorMailManager;

type
  TUnitTestUtils = class
  public
    class function GetLoginFromLocalFile: TLogin;
    class procedure UpdateTestInformationToLocalFile(_Login: TLogin);
    class function GetHostgatorMailManagerFromLocalFile: THostgatorMailManager;
  end;

const
  PASSWORD_PARAM = 'PASSWORD';
  TOKEN_PARAM = 'TOKEN';

implementation

uses
  System.Classes, System.SysUtils, uConsts;

{ TUnitTestUtils }

class function TUnitTestUtils.GetHostgatorMailManagerFromLocalFile: THostgatorMailManager;
var
  ALogin: TLogin;
begin
  Result := THostgatorMailManager.Create;
  try
    ALogin := GetLoginFromLocalFile;
    try
      Result.Domain := ALogin.Domain;
      Result.Token := ALogin.Token;
      Result.HostgatorIP := ALogin.HostgatorHostIP;
      Result.HostgatorUsername := ALogin.HostgatorUsername;
    finally
      ALogin.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TUnitTestUtils.GetLoginFromLocalFile: TLogin;
var
  AStringList: TStringList;
begin
  AStringList := TStringList.Create;
  try
    if not FileExists(COMPANY_FILE) then
      raise Exception.Create('File not exists with login information');

    AStringList.LoadFromFile(COMPANY_FILE);
    Result := TLogin.Create;
    try
      Result.MainAPIUsername := AStringList.Values[SYSTEM_PARAM_MAIN_EMAIL_USERNAME];
      Result.Domain := AStringList.Values[SYSTEM_PARAM_DOMAIN];
      Result.Password := AStringList.Values[PASSWORD_PARAM];
      Result.HostgatorUsername := AStringList.Values[SYSTEM_PARAM_HOSTGATOR_USERNAME];
      Result.HostgatorHostIP := AStringList.Values[SYSTEM_PARAM_HOSTGATOR_HOST_IP];
      Result.Token := AStringList.Values[TOKEN_PARAM];

      Result.MainEmailAPI := Format('%s@%s',[Result.MainAPIUsername, Result.Domain]);
    except
      Result.Free;
      raise;
    end;
  finally
    AStringList.Free;
  end;
end;

class procedure TUnitTestUtils.UpdateTestInformationToLocalFile(_Login: TLogin);
var
  AStringList: TStringList;
begin
  AStringList := TStringList.Create;
  try
    AStringList.LoadFromFile(COMPANY_FILE);
    AStringList.AddPair(PASSWORD_PARAM, _Login.Password);
    AStringList.AddPair(SYSTEM_PARAM_HOSTGATOR_USERNAME, _Login.HostgatorUsername);
    AStringList.AddPair(SYSTEM_PARAM_HOSTGATOR_HOST_IP, _Login.HostgatorHostIP);
    AStringList.AddPair(TOKEN_PARAM, _Login.Token);
    AStringList.SaveToFile(COMPANY_FILE)
  finally
    AStringList.Free;
  end;
end;

end.
