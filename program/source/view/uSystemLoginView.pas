unit uSystemLoginView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uSystemLoginBaseView,
  uADPasswordButtonedEdit, Vcl.ExtCtrls, uADComboBox, Vcl.StdCtrls, Vcl.Mask, uADImage;

type
  TSystemLoginView = class(TSystemLoginBaseView)
    ImageConfig: TImage;
    procedure ImageConfigClick(Sender: TObject);
  private
    procedure ConfigureImage;
    procedure FillLoginInformation;
  protected
    procedure PrepareComponents; override;
  end;

implementation

uses
  uStrHelper, uSystemInfo, uFrameworkMessage, uMessages, uConfigurationView, uSessionManager;

{$R *.dfm}

procedure TSystemLoginView.ConfigureImage;
begin
  ImageConfig.Width := 16;
  ImageConfig.Height := 16;
  AddImageToImageComponent(ImageConfig, TSystemInfo.GetFilePathConfigImage);
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
