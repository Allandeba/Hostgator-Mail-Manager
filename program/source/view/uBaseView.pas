unit uBaseView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrameworkVIew,
  uADPasswordButtonEdit;

type
  TBaseView = class(TFrameworkView)
  private
    procedure AddImage(_AImagePasswordButtonEditList: TImagePasswordButtonEditList; _AImageFilePath: String);
  protected
    procedure AddImagesToADPasswordButtonedEdit(_ADPasswordButtonedEdit: TADPasswordButtonedEdit);
  end;

implementation

uses
  uConsts;

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

end.
