unit uConfigurationView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrameworkView,
  Vcl.ExtCtrls, uADPasswordButtonedEdit, Vcl.StdCtrls, Vcl.Mask, uBaseView;

type
  TConfigurationView = class(TBaseView)
    LabeledEditDomain: TLabeledEdit;
    LabeledEditMainUsername: TLabeledEdit;
    ADPasswordButtonedEditToken: TADPasswordButtonedEdit;
    ButtonSave: TButton;
    ImageTokenInformation: TImage;
    procedure ButtonSaveClick(Sender: TObject);
    procedure ImageTokenInformationClick(Sender: TObject);
  private
    procedure ValidateComponentRequire;
    procedure ValidateRetrievingTokenInformation;
    procedure ValidateTokenInformation;
    procedure FillSessionManager;
    procedure ConfigureReloadImage;
    procedure RetrieveTokenInformation;
  protected
    procedure PrepareComponents; override;
  end;

implementation

uses
  uStrHelper, uSessionManager, uMessages, uTokenManager, uSystemInfo, uFrameworkMessage;

{$R *.dfm}

{ TConfigurationView }

procedure TConfigurationView.ButtonSaveClick(Sender: TObject);
begin
  ValidateComponentRequire;
  FillSessionManager;
  ModalResult := mrOk;
end;

procedure TConfigurationView.ConfigureReloadImage;
begin
  ImageTokenInformation.Width := 16;
  ImageTokenInformation.Height := 16;
  ImageTokenInformation.Hint := 'Retrieve token information';
  AddImageToImageComponent(ImageTokenInformation, TSystemInfo.GetFilePathRetrieveTokenInformationImage);
end;

procedure TConfigurationView.FillSessionManager;
begin
  TSessionManager.GetSessionInfo.TemporaryToken := ADPasswordButtonedEditToken.Text.Trim;
  TSessionManager.GetSessionInfo.Domain := LabeledEditDomain.Text.Trim;
  TSessionManager.GetSessionInfo.MainUsername := LabeledEditMainUsername.Text.Trim;
end;

procedure TConfigurationView.ImageTokenInformationClick(Sender: TObject);
begin
  RetrieveTokenInformation;
end;

procedure TConfigurationView.PrepareComponents;
begin
  inherited;
  AddImagesToADPasswordButtonedEdit(ADPasswordButtonedEditToken);
  LabeledEditDomain.Text := TSessionManager.GetSessionInfo.Domain;
  LabeledEditMainUsername.Text := TSessionManager.GetSessionInfo.MainUsername;
  ConfigureReloadImage;
end;

procedure TConfigurationView.RetrieveTokenInformation;
const
  PASSWORD_CHAR = #9;
var
  APassword: String;
begin
  ValidateRetrievingTokenInformation;
  APassword := InputBox('Retrieve token information', PASSWORD_CHAR + 'Please enter the main user password', '');
  if APassword.IsEmpty then
    Exit;

  ADPasswordButtonedEditToken.Text := TTokenManager.GetToken(APassword);
end;

procedure TConfigurationView.ValidateComponentRequire;
begin
  ValidateTokenInformation;

  if LabeledEditDomain.Text.IsEmpty or LabeledEditMainUsername.Text.IsEmpty then
    TMessageView.New(MSG_0010).ShowAndAbort;
end;

procedure TConfigurationView.ValidateRetrievingTokenInformation;
begin
  if ADPasswordButtonedEditToken.Text.IsEmpty then
    Exit;

  if TMessageView.New(MSG_0014).Buttons([baYesNo]).Warning.ShowResult <> mrYes then
    Abort;
end;

procedure TConfigurationView.ValidateTokenInformation;
begin
  if ADPasswordButtonedEditToken.Text.IsEmpty then
    if TMessageView.New(MSG_0010).Detail('Do you want to retrieve token from localfile?').Buttons([baYesNo]).Warning.ShowResult <> mrYes then
      Abort;

  RetrieveTokenInformation;
end;

end.
