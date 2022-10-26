unit uHostgatorMailManagerController;

interface

uses
  uHostgatorMailManager, System.Classes, uMessages;

type
  THostgatorMailManagerController = class
  private
    procedure PostRequest(_URL: String; _Params: TStringList; _HostgatorMailManager: THostgatorMailManager);
    procedure DealWithHostgatorException(_HostgatorReturnedMessage: String);
    procedure UpdateTokenPassword(_Password: String; _Token: String);

    function GetRequest(_URL: String; _Params: TStringList; _HostgatorMailManager: THostgatorMailManager): String;
    function GetUsernameRequest(_HostgatorMailManager: THostgatorMailManager): String;
  public
    function GetUsernameList(_HostgatorMailManager: THostgatorMailManager): TArray<String>;
    function IsUserAdmin(_Username: String): Boolean;

    procedure AddNewEmail(_HostgatorMailManager: THostgatorMailManager);
    procedure ChangePassword(_HostgatorMailManager: THostgatorMailManager);
    procedure DeleteEmail(_HostgatorMailManager: THostgatorMailManager);
  end;

implementation

uses
  uConsts, uSystemInfo, uRequest, System.SysUtils, System.Generics.Collections, uHostgatorExceptionController, uTokenManager;

{ THostgatorMainManagerController }

procedure THostgatorMailManagerController.AddNewEmail(_HostgatorMailManager: THostgatorMailManager);
var
  AParams: TStringList;
  AURL: String;
begin
  AURL := TSystemInfo.GetURLHostgator(_HostgatorMailManager.HostgatorIP) + HOSTGATOR_MAIL_ADD;

  AParams := TStringList.Create;
  try
    AParams.Add(Format('email=%s@%s', [_HostgatorMailManager.Username, _HostgatorMailManager.Domain]));
    AParams.Add('domain=' + _HostgatorMailManager.Domain);
    AParams.Add('password=' + _HostgatorMailManager.Password);
    AParams.Add('quota=1024');
    AParams.Add('send_welcome_email=1');

    PostRequest(AURL, AParams, _HostgatorMailManager);
  finally
    AParams.Free;
  end;
end;

procedure THostgatorMailManagerController.ChangePassword(_HostgatorMailManager: THostgatorMailManager);
var
  AParams: TStringList;
  AURL: String;
begin
  AURL := TSystemInfo.GetURLHostgator(_HostgatorMailManager.HostgatorIP) + HOSTGATOR_MAIL_UPDATE;

  AParams := TStringList.Create;
  try
    AParams.Add(Format('email=%s@%s', [_HostgatorMailManager.Username, _HostgatorMailManager.Domain]));
    AParams.Add('domain=' + _HostgatorMailManager.Domain);
    AParams.Add('password=' + _HostgatorMailManager.Password);
    AParams.Add('fullEmail=' + _HostgatorMailManager.Email);

    PostRequest(AURL, AParams, _HostgatorMailManager);
  finally
    AParams.Free;
  end;

  if IsUserAdmin(_HostgatorMailManager.Username) then
    UpdateTokenPassword(_HostgatorMailManager.Password, _HostgatorMailManager.Token);
end;

procedure THostgatorMailManagerController.DeleteEmail(_HostgatorMailManager: THostgatorMailManager);
var
  AParams: TStringList;
  AURL: String;
begin
  AURL := TSystemInfo.GetURLHostgator(_HostgatorMailManager.HostgatorIP) + HOSTGATOR_MAIL_DELETE;

  AParams := TStringList.Create;
  try
    AParams.Add(Format('email=%s@%s', [_HostgatorMailManager.Username, _HostgatorMailManager.Domain]));
    PostRequest(AURL, AParams, _HostgatorMailManager);
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

function THostgatorMailManagerController.GetRequest(_URL: String; _Params: TStringList; _HostgatorMailManager: THostgatorMailManager): String;
var
  ARequest: IRequest<String>;
begin
  ARequest := TRequest<String>.Create;
  ARequest
    .New(_URL)
      .AddParams(_Params)
        .Authorization(TSystemInfo.GetAuthorizationToken(_HostgatorMailManager.HostgatorUsername, _HostgatorMailManager.Token));

  Result := ARequest.DoRequest;
end;

function THostgatorMailManagerController.GetUsernameList(_HostgatorMailManager: THostgatorMailManager): TArray<String>;
var
  AContentRequest: String;
  AUsernameList: TList<String>;
  AHostgatorMailManagerUsers: THostgatorMailManagerUsers;
  AHostgatorUserData: THostgatorUserData;
begin
  AContentRequest := GetUsernameRequest(_HostgatorMailManager);
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

function THostgatorMailManagerController.GetUsernameRequest(_HostgatorMailManager: THostgatorMailManager): String;
const
  SORT_ORDER = '1';
  SORT_COLUMN = 'user';
  SORT_FILTER = 'login';

var
  AURL: String;
  AParams: TStringList;
begin
  AURL := TSystemInfo.GetURLHostgator(_HostgatorMailManager.HostgatorIP) + HOSTGATOR_GET_ALL_MAILS;

  AParams := TStringList.Create;
  try
    AParams.Add('api.sort=' + SORT_ORDER);
    AParams.Add('api.sort_column_0=' + SORT_COLUMN);
    AParams.Add('api.filter_term_0=' + _HostgatorMailManager.Domain);
    AParams.Add('api.filter_column_0=' + SORT_FILTER);

    Result := GetRequest(AURL, AParams, _HostgatorMailManager);
  finally
    AParams.Free;
  end;
end;

function THostgatorMailManagerController.IsUserAdmin(_Username: String): Boolean;
begin
  Result := AnsiSameText(_Username, TSystemInfo.GetAPIUsername);
end;

procedure THostgatorMailManagerController.PostRequest(_URL: String; _Params: TStringList; _HostgatorMailManager: THostgatorMailManager);
var
  ARequest: IRequest<String>;
begin
  ARequest := TRequest<String>.Create;
  ARequest
    .New(_URL)
      .AddParams(_Params)
        .Authorization(TSystemInfo.GetAuthorizationToken(_HostgatorMailManager.HostgatorUsername, _HostgatorMailManager.Token))
          .RequestType(roPost);

  DealWithHostgatorException(ARequest.DoRequest);
end;

procedure THostgatorMailManagerController.UpdateTokenPassword(_Password: String; _Token: String);
begin
  TTokenManager.ReplaceToken(_Password, _Token);
end;

end.
