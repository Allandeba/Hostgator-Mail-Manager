unit uLoginController;

interface

uses
  uLogin, System.Classes;

type
  THostgatorResultCode = (hrcFail, hrcSuccess);

  TLoginController = class
  private
    procedure ValidateHostgatorLoginRequest(_RequestContent: String);
    function GetRequestLogin(_LoginValidationParam: TStringList; _URL: String): String;
  public
    procedure ValidateLogin(_Login: TLogin);
  end;

implementation

uses
  uStrHelper, uConsts, uRequest, System.SysUtils, uFrameworkMessages, uMessages, uJSONUtils, idHTTP;

{ TLoginController }

procedure TLoginController.ValidateHostgatorLoginRequest(_RequestContent: String);
const
  HOSTGATOR_RESULT_STATUS = 'status';
var
  AHostgatorServerResult: Integer;
begin
  if _RequestContent.IsEmpty then
    raise Exception.Create(FMSG_0002 + sLineBreak + 'Nothing has returned from hostgator server!' + sLineBreak + 'TLoginController.ValidateHostgatorLoginRequest');

  AHostgatorServerResult := TJSONUtils<Integer>.Parse(HOSTGATOR_RESULT_STATUS, _RequestContent, False);
  if AHostgatorServerResult <> Ord(hrcSuccess) then
    raise Exception.Create(MSG_0004);
end;

procedure TLoginController.ValidateLogin(_Login: TLogin);
var
  ALoginValidationParam: TStringList;
  AURL: String;
  ARequestContent: String;
begin
  AURL := URL_WEBMAIL + _Login.Domain + HOSTGATOR_MAIL_ACCESS;
  ALoginValidationParam := TStringList.Create;
  try
    ALoginValidationParam.Add('user=' + _Login.EmailAddress);
    ALoginValidationParam.Add('pass=' + _Login.Password);

    ARequestContent := GetRequestLogin(ALoginValidationParam, AURL);
    ValidateHostgatorLoginRequest(ARequestContent);
  finally
    ALoginValidationParam.Free;
  end;
end;

function TLoginController.GetRequestLogin(_LoginValidationParam: TStringList; _URL: String): String;
var
  ARequest: IRequest<String>;
begin
  ARequest := TRequest<String>.Create;
  try
    Result :=
      ARequest
        .New(_URL)
          .AddParams(_LoginValidationParam)
            .RequestType(roPost)
              .DoRequest;
  except
    on E: Exception do
      if E is EIdHTTPProtocolException then
        raise Exception.Create(MSG_0004);
  end;
end;

end.
