unit uLoginController;

interface

uses
  System.Classes, uLogin;

type
  THostgatorResultCode = (hrcFail, hrcSuccess);

  TLoginController = class
  private
    procedure ValidateHostgatorLoginException(_RequestContent: String);
    function GetRequestLogin(_LoginValidationParam: TStringList; _URL: String): String;
  public
    procedure ValidateLogin(_Login: TLogin);
    procedure SaveLoginInformation(_Login: TLogin);
  end;

implementation

uses
  uStrHelper, uConsts, uRequest, System.SysUtils, uFrameworkMessages, uMessages, idHTTP, uSystemInfo,
  uHostgatorExceptionController;

{ TLoginController }

procedure TLoginController.SaveLoginInformation(_Login: TLogin);
var
  ALoginInformationParam: TStringList;
begin
  ALoginInformationParam := TStringList.Create;
  try
    ALoginInformationParam.AddPair(SYSTEM_PARAM_DOMAIN, _Login.Domain);
    ALoginInformationParam.AddPair(SYSTEM_PARAM_MAIN_EMAIL_USERNAME, _Login.MainAPIUsername);
    ALoginInformationParam.AddPair(SYSTEM_PARAM_HOSTGATOR_USERNAME, _Login.HostgatorUsername);
    ALoginInformationParam.AddPair(SYSTEM_PARAM_HOSTGATOR_HOST_IP, _Login.HostgatorHostIP);

    ALoginInformationParam.SaveToFile(TSystemInfo.GetFilePathCompanyConfiguration);
  finally
    ALoginInformationParam.Free;
  end;
end;

procedure TLoginController.ValidateHostgatorLoginException(_RequestContent: String);
const
  HOSTGATOR_RESULT_STATUS = 'status';
var
  AHostgatorLoginException: THostgatorLoginException;
begin
  if _RequestContent.IsEmpty then
    raise Exception.Create(Format(FMSG_0002, ['Nothing has returned from hostgator server!' + sLineBreak + 'TLoginController.ValidateHostgatorLoginRequest']));

  AHostgatorLoginException := THostgatorLoginException.Create;
  try
    AHostgatorLoginException.AsJson := _RequestContent;
    if AHostgatorLoginException.Status <> Ord(hrcSuccess) then
      raise Exception.Create(MSG_0004);
  finally
    AHostgatorLoginException.Free;
  end;
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
    ALoginValidationParam.Add('user=' + _Login.MainEmailAPI);
    ALoginValidationParam.Add('pass=' + _Login.Password);

    ARequestContent := GetRequestLogin(ALoginValidationParam, AURL);
    ValidateHostgatorLoginException(ARequestContent);
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
