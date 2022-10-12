unit uSystemLoginBaseView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  uADPasswordButtonEdit, uADComboBox, uFrameworkView, System.Classes;

type
  TSystemLoginBaseView = class(TFrameworkView)
    ButtonLogin: TButton;
    ADComboBoxCompany: TADComboBox;
    ADPasswordButtonedEdit: TADPasswordButtonedEdit;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ButtonLoginClick(Sender: TObject);
  private
    procedure EnabledComponentes;
    procedure ConfigureADButtonedPasswordEditImages;
    procedure AddImage(_AImagePasswordButtonEditList: TImagePasswordButtonEditList; _AImageFilePath: String);

    procedure DoOnKeyDownADPasswordButtonedEdit(_Sender: TObject; var _Key: Word; _Shift: TShiftState);
  protected
    procedure PrepareComponents; override;
    procedure PrepareEvents; override;
  end;

implementation

uses
  uConsts, Vcl.Imaging.pngimage;

{$R *.dfm}

procedure TSystemLoginBaseView.AddImage(_AImagePasswordButtonEditList: TImagePasswordButtonEditList; _AImageFilePath: String);
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

procedure TSystemLoginBaseView.ButtonLoginClick(Sender: TObject);
begin
  raise ENotImplemented.Create('Not implemented');
end;

procedure TSystemLoginBaseView.ConfigureADButtonedPasswordEditImages;
var
  AImagePasswordButtonEditList: TImagePasswordButtonEditList;
begin
  AImagePasswordButtonEditList := TImagePasswordButtonEditList.Create;
  try
    AddImage(AImagePasswordButtonEditList, IMG_BUTTON_PASSWORD_1);
    AddImage(AImagePasswordButtonEditList, IMG_BUTTON_PASSWORD_2);

    ADPasswordButtonedEdit.AddImages(AImagePasswordButtonEditList);
  finally
    AImagePasswordButtonEditList.Free;
  end;
end;

procedure TSystemLoginBaseView.DoOnKeyDownADPasswordButtonedEdit(_Sender: TObject; var _Key: Word; _Shift: TShiftState);
begin
  if (_Key = VK_RETURN) and ButtonLogin.Enabled then
    ButtonLogin.Click;
end;

procedure TSystemLoginBaseView.EnabledComponentes;
begin
  ButtonLogin.Enabled := ADComboBoxCompany.ComboBox.Text <> '';
end;

procedure TSystemLoginBaseView.FormKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  EnabledComponentes;
end;

procedure TSystemLoginBaseView.PrepareComponents;
begin
  inherited;
  ADComboBoxCompany.TabStop := False;
  ButtonLogin.ModalResult := mrNone;
  ConfigureADButtonedPasswordEditImages;
  EnabledComponentes;
end;

procedure TSystemLoginBaseView.PrepareEvents;
begin
  inherited;
  ADPasswordButtonedEdit.PasswordButtonedEdit.OnKeyDown := DoOnKeyDownADPasswordButtonedEdit;
end;

end.
