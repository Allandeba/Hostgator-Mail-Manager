unit uConfigurationView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrameworkView,
  Vcl.ExtCtrls, uADPasswordButtonEdit, Vcl.StdCtrls, Vcl.Mask, uBaseView;

type
  TConfigurationView = class(TBaseView)
    LabeledEditDomain: TLabeledEdit;
    LabeledEditMainUsername: TLabeledEdit;
    ADPasswordButtonedEditToken: TADPasswordButtonedEdit;
    ButtonSave: TButton;
    procedure ButtonSaveClick(Sender: TObject);
  private
    procedure ValidateComponentRequire;
    procedure FillSessionManager;
  protected
    procedure PrepareComponents; override;
  end;

implementation

uses
  uStrHelper, uSessionManager, uFrameworkMessage, uMessages;

{$R *.dfm}

{ TConfigurationView }

procedure TConfigurationView.ButtonSaveClick(Sender: TObject);
begin
  ValidateComponentRequire;
  FillSessionManager;
  ModalResult := mrOk;
end;

procedure TConfigurationView.FillSessionManager;
begin
  TSessionManager.GetSessionInfo.Token := ADPasswordButtonedEditToken.Text.Trim;
  TSessionManager.GetSessionInfo.Domain := LabeledEditDomain.Text.Trim;
  TSessionManager.GetSessionInfo.MainUsername := LabeledEditMainUsername.Text.Trim;
end;

procedure TConfigurationView.PrepareComponents;
begin
  inherited;
  AddImagesToADPasswordButtonedEdit(ADPasswordButtonedEditToken);
  ADPasswordButtonedEditToken.Text := TSessionManager.GetSessionInfo.Token;
  LabeledEditDomain.Text := TSessionManager.GetSessionInfo.Domain;
  LabeledEditMainUsername.Text := TSessionManager.GetSessionInfo.GetMainAPIMail;
end;

procedure TConfigurationView.ValidateComponentRequire;
begin
  if ADPasswordButtonedEditToken.Text.IsEmpty or LabeledEditDomain.Text.IsEmpty or LabeledEditMainUsername.Text.IsEmpty then
    TMessageView.New(MSG_0010).ShowAndAbort;
end;

end.
