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
    LabeledEditHostgatorUsername: TLabeledEdit;
    LabeledEditHostgatorHostIP: TLabeledEdit;
    procedure ButtonSaveClick(Sender: TObject);
    procedure ImageTokenInformationClick(Sender: TObject);
  private
    procedure ValidateComponentRequire;
    procedure ValidateTokenInformation;
    procedure FillSessionManager;
    procedure ConfigureReloadImage;
    procedure RetrieveTokenInformation;

    function CanLoadTokenFromLocalFile: Boolean;
  protected
    procedure PrepareComponents; override;
  end;

implementation

uses
  uStrHelper, uSessionManager, uMessages, uSystemInfo, uFrameworkMessage;

{$R *.dfm}

{ TConfigurationView }

procedure TConfigurationView.ButtonSaveClick(Sender: TObject);
begin
  ValidateComponentRequire;
  FillSessionManager;
  ModalResult := mrOk;
end;

function TConfigurationView.CanLoadTokenFromLocalFile: Boolean;
begin
  Result := FileExists(TSystemInfo.GetFilePathTokenConfiguration);
end;

procedure TConfigurationView.ConfigureReloadImage;
begin
  ImageTokenInformation.Width := 16;
  ImageTokenInformation.Height := 16;
  ImageTokenInformation.Hint := 'Retrieve token information';
  ImageTokenInformation.ShowHint := True;
  AddImageToImageComponent(ImageTokenInformation, TSystemInfo.GetFilePathRetrieveTokenInformationImage);
end;

procedure TConfigurationView.FillSessionManager;
begin
  TSessionManager.GetSessionInfo.Token := ADPasswordButtonedEditToken.Text.Trim;
  TSessionManager.GetSessionInfo.Domain := LabeledEditDomain.Text.Trim;
  TSessionManager.GetSessionInfo.MainEmailUsername := LabeledEditMainUsername.Text.Trim;
  TSessionManager.GetSessionInfo.HostgatorUsername := LabeledEditHostgatorUsername.Text.Trim;
  TSessionManager.GetSessionInfo.HostgatorHostIP := LabeledEditHostgatorHostIP.Text.Trim;
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
  LabeledEditMainUsername.Text := TSessionManager.GetSessionInfo.MainEmailUsername;
  LabeledEditHostgatorUsername.Text := TSessionManager.GetSessionInfo.HostgatorUsername;
  LabeledEditHostgatorHostIP.Text := TSessionManager.GetSessionInfo.HostgatorHostIP;
  ConfigureReloadImage;
end;

procedure TConfigurationView.RetrieveTokenInformation;
begin
  if not ADPasswordButtonedEditToken.Text.IsEmpty then
    if TMessageView.New(MSG_0014).Buttons([baYesNo]).Warning.ShowResult <> mrYes then
      Abort;

  ADPasswordButtonedEditToken.Text := inherited GetTokenInformation;
end;

procedure TConfigurationView.ValidateComponentRequire;
begin
  ValidateTokenInformation;

  if LabeledEditDomain.Text.IsEmpty or LabeledEditMainUsername.Text.IsEmpty then
    TMessageView.New(MSG_0010).ShowAndAbort;
end;

procedure TConfigurationView.ValidateTokenInformation;
begin
  if ADPasswordButtonedEditToken.Text.IsEmpty then
  begin
    if not CanLoadTokenFromLocalFile then
      TMessageView.New(MSG_0010).ShowAndAbort;

    if TMessageView.New(MSG_0010).Detail('Do you want to retrieve token from localfile?').Buttons([baYesNo]).Warning.ShowResult <> mrYes then
      Abort;

    GetTokenInformation;
  end;
end;

end.
