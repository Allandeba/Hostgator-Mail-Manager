unit uSystemLoginView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uSystemLoginBaseView,
  uADPasswordButtonedEdit, Vcl.ExtCtrls, uADComboBox, Vcl.StdCtrls, Vcl.Mask, uLoginController, uLogin, VCLTee.TeeProcs, uADCustomPanelNoCaption;

type
  TSystemLoginView = class(TSystemLoginBaseView)
    ImageConfig: TImage;
    procedure ImageConfigClick(Sender: TObject);
    procedure ButtonLoginClick(Sender: TObject);
  private
    FLoginController: TLoginController;
    procedure ConfigureImage;
    procedure FillLoginInformation;
    procedure LoadToken(_Password: String);

    function GetLoginInformation: TLogin;
    function GetLoginController: TLoginController;
    property LoginController: TLoginController read GetLoginController;
  protected
    procedure PrepareComponents; override;
  public
    destructor Destroy; override;
  end;

implementation

uses
  uStrHelper, uSystemInfo, uFrameworkMessage, uMessages, uConfigurationView, uSessionManager, uTokenManager;

{$R *.dfm}

procedure TSystemLoginView.ButtonLoginClick(Sender: TObject);
var
  ALogin: TLogin;
begin
  Repaint; // Todo: It needs to be repainted every OnClick with mouse click because it loses the style.
  ALogin := GetLoginInformation;
  try
    LoginController.ValidateLogin(ALogin);
    LoginController.SaveLoginInformation(ALogin);
    LoadToken(ALogin.Password);
  finally
    ALogin.Free;
  end;

  ModalResult := mrOk;
end;

procedure TSystemLoginView.ConfigureImage;
begin
  ImageConfig.Width := 16;
  ImageConfig.Height := 16;
  AddImageToImageComponent(ImageConfig, TSystemInfo.GetFilePathConfigImage);
end;

destructor TSystemLoginView.Destroy;
begin
  FLoginController.Free;
  inherited;
end;

procedure TSystemLoginView.FillLoginInformation;
begin
  LabeledEditUsername.Text := TSessionManager.GetSessionInfo.GetMainAPIMail;
end;

function TSystemLoginView.GetLoginController: TLoginController;
begin
  if FLoginController = nil then
    FLoginController := TLoginController.Create;
  Result := FLoginController;
end;

function TSystemLoginView.GetLoginInformation: TLogin;
begin
  Result := TLogin.Create;
  try
    Result.MainEmailAPI :=  TSessionManager.GetSessionInfo.GetMainAPIMail;
    Result.MainAPIUsername := TSessionManager.GetSessionInfo.MainEmailUsername;
    Result.HostgatorUsername := TSessionManager.GetSessionInfo.HostgatorUsername;
    Result.Domain := TSessionManager.GetSessionInfo.Domain;
    Result.HostgatorHostIP := TSessionManager.GetSessionInfo.HostgatorHostIP;
    Result.Password := ADPasswordButtonedEdit.Text;
    Result.Token := TSessionManager.GetSessionInfo.Token;
  except
    Result.Free;
    raise;
  end;
end;

procedure TSystemLoginView.ImageConfigClick(Sender: TObject);
var
  AConfigurationView: TConfigurationView;
begin
  AConfigurationView := TConfigurationView.Create(Self);
  try
    if AConfigurationView.ShowModal = mrOk then
    begin
      FillLoginInformation;
      ControlDefaultFocus;
    end;
  finally
    AConfigurationView.Free;
  end;
end;

procedure TSystemLoginView.LoadToken(_Password: String);
begin
  if not TSessionManager.GetSessionInfo.Token.IsEmpty then
    TTokenManager.ReplaceToken(_Password, TSessionManager.GetSessionInfo.Token)
  else
    TSessionManager.GetSessionInfo.Token := TTokenManager.GetToken(_Password);
end;

procedure TSystemLoginView.PrepareComponents;
begin
  inherited;
  ConfigureImage;
end;

end.
