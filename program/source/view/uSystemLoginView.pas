unit uSystemLoginView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uSystemLoginBaseView,
  uADPasswordButtonEdit, Vcl.ExtCtrls, uADComboBox, Vcl.StdCtrls, Vcl.Mask;

type
  TSystemLoginView = class(TSystemLoginBaseView)
    ImageConfig: TImage;
    procedure ImageConfigClick(Sender: TObject);
  private
    procedure ConfigureImage;
    procedure FillLoginInformation;
    procedure ControlComponentsEnabled;

    function CanFillLoginInformation: Boolean;
  protected
    procedure PrepareComponents; override;
  end;

implementation

uses
  uStrHelper, uSystemInfo, uFrameworkMessage, uMessages, uConfigurationView, uSessionManager;

{$R *.dfm}

function TSystemLoginView.CanFillLoginInformation: Boolean;
begin
  Result := LabeledEditUsername.Text.IsEmpty;
end;

procedure TSystemLoginView.ConfigureImage;
var
  AImageFilePath: String;
begin
  AImageFilePath := TSystemInfo.GetFilePathConfigImage;
  if not FileExists(AImageFilePath) then
    TMessageView.New(MSG_0012).Detail(Format('%s\nTSystemLoginView.ConfigureImage', [AImageFilePath])).ShowAndAbort;

  ImageConfig.Picture.LoadFromFile(AImageFilePath);
end;

procedure TSystemLoginView.ControlComponentsEnabled;
begin
  ButtonLogin.Enabled := not LabeledEditUsername.Text.IsEmpty;
end;

procedure TSystemLoginView.FillLoginInformation;
begin
  LabeledEditUsername.Text := TSessionManager.GetSessionInfo.GetMainAPIMail;
end;

procedure TSystemLoginView.ImageConfigClick(Sender: TObject);
var
  AConfigurationView: TConfigurationView;
begin
  AConfigurationView := TConfigurationView.Create(Self);
  try
    if (AConfigurationView.ShowModal = mrOk) and CanFillLoginInformation then
    begin
      FillLoginInformation;
      if ADPasswordButtonedEdit.CanFocus then
        ADPasswordButtonedEdit.SetFocus;
      ControlComponentsEnabled;
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
