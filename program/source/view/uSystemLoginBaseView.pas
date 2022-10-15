unit uSystemLoginBaseView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  uADPasswordButtonEdit, uADComboBox, uFrameworkView, System.Classes, Vcl.Mask, uBaseView;

type
  TSystemLoginBaseView = class(TBaseView)
    ButtonLogin: TButton;
    LabeledEditUsername: TLabeledEdit;
    ADPasswordButtonedEdit: TADPasswordButtonedEdit;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ButtonLoginClick(Sender: TObject);
  private
    procedure EnabledComponentes;
    procedure DoOnKeyDownADPasswordButtonedEdit(_Sender: TObject; var _Key: Word; _Shift: TShiftState);
  protected
    procedure PrepareComponents; override;
    procedure PrepareEvents; override;
  end;

implementation

uses
  uConsts, Vcl.Imaging.pngimage, uStrHelper;

{$R *.dfm}

procedure TSystemLoginBaseView.ButtonLoginClick(Sender: TObject);
begin
  raise ENotImplemented.Create('Not implemented');
end;

procedure TSystemLoginBaseView.DoOnKeyDownADPasswordButtonedEdit(_Sender: TObject; var _Key: Word; _Shift: TShiftState);
begin
  if (_Key = VK_RETURN) and ButtonLogin.Enabled then
    ButtonLogin.Click;
end;

procedure TSystemLoginBaseView.EnabledComponentes;
begin
  ButtonLogin.Enabled := not LabeledEditUsername.Text.IsEmpty;
end;

procedure TSystemLoginBaseView.FormKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  EnabledComponentes;
end;

procedure TSystemLoginBaseView.PrepareComponents;
begin
  inherited;
  ButtonLogin.ModalResult := mrNone;
  BorderStyle := bsDialog;
  AddImagesToADPasswordButtonedEdit(ADPasswordButtonedEdit);
  EnabledComponentes;
end;

procedure TSystemLoginBaseView.PrepareEvents;
begin
  inherited;
  ADPasswordButtonedEdit.OnKeyDown := DoOnKeyDownADPasswordButtonedEdit;
end;

end.
