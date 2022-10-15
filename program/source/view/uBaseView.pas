unit uBaseView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrameworkVIew,
  uADPasswordButtonedEdit, Vcl.ExtCtrls;

type
  TBaseView = class(TFrameworkView)
  private
    procedure AddImage(_AImagePasswordButtonEditList: TImagePasswordButtonEditList; _AImageFilePath: String);
  protected
    procedure AddImagesToADPasswordButtonedEdit(_ADPasswordButtonedEdit: TADPasswordButtonedEdit);
    procedure AddImageToImageComponent(_Image: TImage; _ImageFilePath: String);
    procedure PrepareComponents; override;
  end;

implementation

uses
  uConsts, uFrameworkMessage, uMessages;

{$R *.dfm}

{ TBaseView }

procedure TBaseView.AddImage(_AImagePasswordButtonEditList: TImagePasswordButtonEditList; _AImageFilePath: String);
var
  AImagePasswordButtonEdit: TImagePasswordButtonEdit;
begin
  AImagePasswordButtonEdit := TImagePasswordButtonEdit.Create;
  try
    AImagePasswordButtonEdit.Filename := _AImageFilePath;
    AImagePasswordButtonEdit.IsPressedImage := True;

    _AImagePasswordButtonEditList.Add(AImagePasswordButtonEdit);
  except
    AImagePasswordButtonEdit.Free;
    raise;
  end;
end;

procedure TBaseView.AddImagesToADPasswordButtonedEdit(_ADPasswordButtonedEdit: TADPasswordButtonedEdit);
var
  AImagePasswordButtonEditList: TImagePasswordButtonEditList;
begin
  AImagePasswordButtonEditList := TImagePasswordButtonEditList.Create;
  try
    AddImage(AImagePasswordButtonEditList, IMG_BUTTON_PASSWORD_1);
    AddImage(AImagePasswordButtonEditList, IMG_BUTTON_PASSWORD_2);

    _ADPasswordButtonedEdit.AddImages(AImagePasswordButtonEditList);
  finally
    AImagePasswordButtonEditList.Free;
  end;
end;

procedure TBaseView.AddImageToImageComponent(_Image: TImage; _ImageFilePath: String);
begin
  if not FileExists(_ImageFilePath) then
    TMessageView.New(MSG_0012).Detail(Format('%s\nTSystemLoginView.ConfigureImage', [_ImageFilePath])).ShowAndAbort;

  _Image.Picture.LoadFromFile(_ImageFilePath);
end;

procedure TBaseView.PrepareComponents;
begin
  inherited;
  BorderStyle := bsDialog;
end;

end.
