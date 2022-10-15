unit uTokenManager;

interface

uses
  System.Classes, uCryptography;

type
  TTokenManager = class
  private
    class function DecryptFile(_TokenInformation: TStringList; _Password: String): String;
    class function Decrypt(_Cryptography: TCryptography): String;
  public
    class function GetToken(_Password: String): String;
  end;

implementation

uses
  uSystemInfo, uFrameworkConsts, uStrHelper, uConsts, uCryptographer, System.SysUtils, uMessages;

{ TTokenManager }

class function TTokenManager.Decrypt(_Cryptography: TCryptography): String;
begin
  if _Cryptography = nil then
    raise Exception.Create(MSG_0002 + '_Cryptography = nil - TTokenManager.Decrypt');

  try
    Result := TCryptographer.New(_Cryptography).Decrypt;
  except
    on E: Exception do
      raise Exception.Create(MSG_0002 + sLineBreak + 'TTokenManager.Decrypt(' + sLineBreak + E.Message);
  end;
end;

class function TTokenManager.DecryptFile(_TokenInformation: TStringList; _Password: String): String;
var
  ACryptography: TCryptography;
begin
  ACryptography := TCryptography.Create;
  try
    ACryptography.Token := TOKEN_CRIPTOGRAFADOR;
    ACryptography.Password := _Password;
    ACryptography.Message := _TokenInformation.Text;
    Decrypt(ACryptography);
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

end.
