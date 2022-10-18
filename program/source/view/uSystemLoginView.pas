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
  APassword: String;
begin
  APassword := ADPasswordButtonedEdit.Text;
  LoginController.ValidateLogin(APassword);
  TTokenManager.ProcessTokenInformation(APassword);
  LoginController.SaveLoginInformation;
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

end.
