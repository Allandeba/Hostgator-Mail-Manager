unit uHostgatorMailManagerController;

interface

uses
  uHostgatorMailManager, System.Classes, uMessages;

type
  THostgatorMailManagerController = class
  private
    procedure PostRequest(_URL: String; _Params: TStringList);
    procedure DealWithHostgatorException(_HostgatorReturnedMessage: String);
    procedure UpdateTokenPassword(_Password: String);

    function GetRequest(_URL: String; _Params: TStringList): String;
    function GetUsernameRequest: String;
  public
    function GetUsernameList: TArray<String>;
    function IsUserAdmin(_Username: String): Boolean;

    procedure AddNewEmail(_Username, _Password: String);
    procedure ChangePassword(_Username, _Password: String);
    procedure DeleteEmail(_Username: String);
  end;

implementation

uses
  uSessionManager, uConsts, uSystemInfo, uRequest, uStrHelper, System.SysUtils, REST.Json, System.JSON, System.Generics.Collections,
  uHostgatorExceptionController, uTokenManager;

{ THostgatorMainManagerController }

procedure THostgatorMailManagerController.AddNewEmail(_Username, _Password: String);
var
  AParams: TStringList;
  AURL: String;
begin
  AURL := TSystemInfo.GetURLHostgator + HOSTGATOR_MAIL_ADD;

  AParams := TStringList.Create;
  try
    AParams.Add(Format('email=%s@%s', [_Username, TSessionManager.GetSessionInfo.Domain]));
    AParams.Add('domain=' + TSessionManager.GetSessionInfo.Domain);
    AParams.Add('password=' + _Password);
    AParams.Add('quota=1024');
    AParams.Add('send_welcome_email=1');

    PostRequest(AURL, AParams);
  finally
    AParams.Free;
  end;
end;

procedure THostgatorMailManagerController.ChangePassword(_Username, _Password: String);
var
  AParams: TStringList;
  AURL: String;
begin
  AURL := TSystemInfo.GetURLHostgator + HOSTGATOR_MAIL_UPDATE;

  AParams := TStringList.Create;
  try
    AParams.Add(Format('email=%s@%s', [_Username, TSessionManager.GetSessionInfo.Domain]));
    AParams.Add('domain=' + TSessionManager.GetSessionInfo.Domain);
    AParams.Add('password=' + _Password);
    AParams.Add('fullEmail=' + TSessionManager.GetSessionInfo.GetMainAPIMail);

    PostRequest(AURL, AParams);
  finally
    AParams.Free;
  end;

  if IsUserAdmin(_Username) then
    UpdateTokenPassword(_Password);
end;

procedure THostgatorMailManagerController.DeleteEmail(_Username: String);
var
  AParams: TStringList;
  AURL: String;
begin
  AURL := TSystemInfo.GetURLHostgator + HOSTGATOR_MAIL_DELETE;

  AParams := TStringList.Create;
  try
    AParams.Add(Format('email=%s@%s', [_Username, TSessionManager.GetSessionInfo.Domain]));
    PostRequest(AURL, AParams);
  finally
    AParams.Free;
  end;
end;

procedure THostgatorMailManagerController.DealWithHostgatorException(_HostgatorReturnedMessage: String);
var
  AHostgatorExceptionController: THostgatorExceptionController;
  AErrorMessage: String;
  ACatchedErrors: String;
begin
  ACatchedErrors := '';
  AHostgatorExceptionController := THostgatorExceptionController.Create;
  try
    AHostgatorExceptionController.AsJson := _HostgatorReturnedMessage;
    for AErrorMessage in AHostgatorExceptionController.Errors do
    begin
      if AErrorMessage = HOSTGATOR_RETURN_MAIL_MESSAGE_OK then
        Continue;

      ACatchedErrors := ACatchedErrors + sLineBreak + AErrorMessage;
    end;

    if Length(ACatchedErrors) > 0 then
      raise Exception.Create(Format(MSG_0002, [ACatchedErrors]));
  finally
    AHostgatorExceptionController.Free;
  end;
end;

function THostgatorMailManagerController.GetRequest(_URL: String; _Params: TStringList): String;
var
  ARequest: IRequest<String>;
begin
  ARequest := TRequest<String>.Create;
  ARequest
    .New(_URL)
      .AddParams(_Params)
        .Authorization(TSystemInfo.GetAuthorizationToken);

  Result := ARequest.DoRequest;
end;

function THostgatorMailManagerController.GetUsernameList: TArray<String>;
var
  AContentRequest: String;
  AUsernameList: TList<String>;
  AHostgatorMailManagerUsers: THostgatorMailManagerUsers;
  AHostgatorUserData: THostgatorUserData;
begin
  AContentRequest := GetUsernameRequest;
  if AContentRequest.IsEmpty then
    raise Exception.Create(MSG_0005 + sLineBreak + 'THostgatorMailManagerController.GetUsernameList');

  AUsernameList := TList<String>.Create;
  try
    AHostgatorMailManagerUsers := THostgatorMailManagerUsers.Create;
    try
      AHostgatorMailManagerUsers.AsJson := AContentRequest;
      for AHostgatorUserData in AHostgatorMailManagerUsers.Data do
      begin
        if not AUsernameList.Contains(AHostgatorUserData.User) then
          AUsernameList.Add(AHostgatorUserData.User);
      end;
    finally
      AHostgatorMailManagerUsers.Free;
    end;

    Result := AUsernameList.ToArray;
  finally
    AUsernameList.Free;
  end;
end;

function THostgatorMailManagerController.GetUsernameRequest: String;
const
  SORT_ORDER = '1';
  SORT_COLUMN = 'user';
  SORT_FILTER = 'login';

var
  AURL: String;
  AParams: TStringList;
begin
  AURL := TSystemInfo.GetURLHostgator + HOSTGATOR_GET_ALL_MAILS;

  AParams := TStringList.Create;
  try
    AParams.Add('api.sort=' + SORT_ORDER);
    AParams.Add('api.sort_column_0=' + SORT_COLUMN);
    AParams.Add('api.filter_term_0=' + TSessionManager.GetSessionInfo.Domain);
    AParams.Add('api.filter_column_0=' + SORT_FILTER);

    Result := GetRequest(AURL, AParams);
  finally
    AParams.Free;
  end;
end;



function THostgatorMailManagerController.IsUserAdmin(_Username: String): Boolean;
begin
  Result := AnsiSameText(_Username, TSessionManager.GetSessionInfo.MainEmailUsername)
end;

procedure THostgatorMailManagerController.PostRequest(_URL: String; _Params: TStringList);
var
  ARequest: IRequest<String>;
begin
  ARequest := TRequest<String>.Create;
  ARequest
    .New(_URL)
      .AddParams(_Params)
        .Authorization(TSystemInfo.GetAuthorizationToken)
          .RequestType(roPost);

  DealWithHostgatorException(ARequest.DoRequest);
end;

procedure THostgatorMailManagerController.UpdateTokenPassword(_Password: String);
begin
  TTokenManager.ReplaceToken(_Password);
end;

end.
