unit uSystemLoginView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uSystemLoginBaseView,
  uADPasswordButtonEdit, Vcl.ExtCtrls, uADComboBox, Vcl.StdCtrls;

type
  TSystemLoginView = class(TSystemLoginBaseView)
    ImageConfig: TImage;
    procedure ImageConfigClick(Sender: TObject);
  private
    procedure ConfigureImage;
  protected
    procedure PrepareComponents; override;
  end;

implementation

uses
  uSystemInfo, uFrameworkMessage, uMessages;

{$R *.dfm}

procedure TSystemLoginView.ConfigureImage;
var
  AImageFilePath: String;
begin
  AImageFilePath := TSystemInfo.GetFilePathConfigImage;
  if not FileExists(AImageFilePath) then
    TMessageView.New(MSG_0012).Detail(Format('%s\nTSystemLoginView.ConfigureImage', [AImageFilePath])).ShowAndAbort;

  ImageConfig.Picture.LoadFromFile(AImageFilePath);
end;

procedure TSystemLoginView.ImageConfigClick(Sender: TObject);
begin
  raise ENotImplemented.Create('Not implemented');
end;

procedure TSystemLoginView.PrepareComponents;
begin
  inherited;
  ConfigureImage;
end;

end.
