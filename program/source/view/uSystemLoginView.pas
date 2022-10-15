unit uSystemLoginView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uSystemLoginBaseView,
  uADPasswordButtonedEdit, Vcl.ExtCtrls, uADComboBox, Vcl.StdCtrls, Vcl.Mask, uLoginController;

type
  TSystemLoginView = class(TSystemLoginBaseView)
    ImageConfig: TImage;
    procedure ImageConfigClick(Sender: TObject);
    procedure ButtonLoginClick(Sender: TObject);
  private
    FLoginController: TLoginController;
    procedure ConfigureImage;
    procedure FillLoginInformation;
    procedure ValidateLogin;

    function GetLoginController: TLoginController;
    property LoginController: TLoginController read GetLoginController;
  protected
    procedure PrepareComponents; override;
  public
    destructor Destroy; override;
  end;

implementation

uses
  uStrHelper, uSystemInfo, uFrameworkMessage, uMessages, uConfigurationView, uSessionManager, uLogin;

{$R *.dfm}

procedure TSystemLoginView.ButtonLoginClick(Sender: TObject);
begin
  ValidateLogin;
  raise ENotImplemented.Create('Logged in successfully');
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

procedure TSystemLoginView.PrepareComponents;
begin
  inherited;
  ConfigureImage;
end;

procedure TSystemLoginView.ValidateLogin;
var
  ALogin: TLogin;
begin
  ALogin := TLogin.Create;
  try
    ALogin.EmailAddress := LabeledEditUsername.Text.Trim;
    ALogin.Domain := TSessionManager.GetSessionInfo.Domain;
    ALogin.Password := ADPasswordButtonedEdit.Text;

    LoginController.ValidateLogin(ALogin);
  finally
    ALogin.Free;
  end;
end;

end.
