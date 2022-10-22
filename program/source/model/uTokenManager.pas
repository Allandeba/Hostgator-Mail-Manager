unit uTokenManager;

interface

uses
  System.Classes, uCryptography;

type
  TTokenManager = class
  private
    class function HadTokenUpdate: Boolean;
    class procedure SaveToken(_Password: String);

    class function DecryptFile(_TokenInformationParam: TStringList; _Password: String): String;
    class function Decrypt(_Cryptography: TCryptography): String;
    class function EncryptFile(_TokenInformationParam: TStringList; _Password: String): String;
  public
    class procedure ProcessTokenInformation(_Password: String);
    class procedure ReplaceToken(_Password: String);
    class function GetToken(_Password: String): String;
  end;

implementation

uses
  uSystemInfo, uFrameworkConsts, uConsts, uCryptographer, System.SysUtils, uMessages, uSessionManager;

{ TTokenManager }

class function TTokenManager.Decrypt(_Cryptography: TCryptography): String;
begin
  if _Cryptography = nil then
    raise Exception.Create(Format(MSG_0002, ['_Cryptography = nil - TTokenManager.Decrypt']));

  try
    Result := TCryptographer.New(_Cryptography).Decrypt;
  except
    on E: Exception do
      raise Exception.Create(MSG_0004);
  end;
end;

class function TTokenManager.DecryptFile(_TokenInformationParam: TStringList; _Password: String): String;
var
  ACryptography: TCryptography;
begin
  ACryptography := TCryptography.Create;
  try
    ACryptography.Token := TOKEN_CRIPTOGRAFADOR;
    ACryptography.Password := _Password;
    ACryptography.Message := _TokenInformationParam.Text;
    Result := Decrypt(ACryptography);
  finally
    ACryptography.Free;
  end;
end;

class function TTokenManager.EncryptFile(_TokenInformationParam: TStringList; _Password: String): String;
var
  ACryptography: TCryptography;
begin
  ACryptography := TCryptography.Create;
  try
    ACryptography.Token := TOKEN_CRIPTOGRAFADOR;
    ACryptography.Password := _Password;
    ACryptography.Message := _TokenInformationParam.Text;
    Result := TCryptographer.New(ACryptography).Encrypt;
  finally
    ACryptography.Free;
  end;
end;

class function TTokenManager.GetToken(_Password: String): String;
var
  ATokenInformation: TStringList;
  ATokenDecrypted: String;
begin
  ATokenInformation := TStringList.Create;
  try
    ATokenInformation.LoadFromFile(TSystemInfo.GetFilePathTokenConfiguration);
    ATokenDecrypted := DecryptFile(ATokenInformation, _Password);

    ATokenInformation.Clear;
    ATokenInformation.Text := ATokenDecrypted;
    Result := ATokenInformation.Values[TOKEN_PARAM].Trim;
  finally
    ATokenInformation.Free;
  end;
end;

class function TTokenManager.HadTokenUpdate: Boolean;
begin
  Result := not TSessionManager.GetSessionInfo.Token.IsEmpty;
end;

class procedure TTokenManager.ProcessTokenInformation(_Password: String);
begin
  if HadTokenUpdate then
    SaveToken(_Password)
  else
    TSessionManager.GetSessionInfo.Token := GetToken(_Password);
end;

class procedure TTokenManager.ReplaceToken(_Password: String);
begin
  SaveToken(_Password);
end;

class procedure TTokenManager.SaveToken(_Password: String);
var
  ATokenInformationParam: TStringList;
  AEncryptedToken: String;
begin
  ATokenInformationParam := TStringList.Create;
  try
    ATokenInformationParam.AddPair(TOKEN_PARAM, TSessionManager.GetSessionInfo.Token);

    AEncryptedToken := EncryptFile(ATokenInformationParam, _Password);

    ATokenInformationParam.Clear;
    ATokenInformationParam.Text := AEncryptedToken;
    ATokenInformationParam.SaveToFile(TSystemInfo.GetFilePathTokenConfiguration);
  finally
    ATokenInformationParam.Free;
  end;
end;

end.
