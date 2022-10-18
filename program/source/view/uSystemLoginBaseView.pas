unit uSystemLoginBaseView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  uADPasswordButtonedEdit, uADComboBox, uFrameworkView, System.Classes, Vcl.Mask, uBaseView;

type
  TSystemLoginBaseView = class(TBaseView)
    ButtonLogin: TButton;
    LabeledEditUsername: TLabeledEdit;
    ADPasswordButtonedEdit: TADPasswordButtonedEdit;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ButtonLoginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure EnabledComponentes;
    procedure LoadLoginInformation;
    procedure DoOnKeyDownADPasswordButtonedEdit(_Sender: TObject; var _Key: Word; _Shift: TShiftState);
  protected
    procedure PrepareComponents; override;
    procedure PrepareEvents; override;
    procedure ControlDefaultFocus;
  end;

implementation

uses
  uStrHelper, uSessionManager;

{$R *.dfm}

procedure TSystemLoginBaseView.ButtonLoginClick(Sender: TObject);
begin
  raise ENotImplemented.Create('Not implemented');
end;

procedure TSystemLoginBaseView.ControlDefaultFocus;
begin
  if LabeledEditUsername.Text.IsEmpty then
    Exit;

  if ADPasswordButtonedEdit.CanFocus then
    ADPasswordButtonedEdit.SetFocus;
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

procedure TSystemLoginBaseView.FormShow(Sender: TObject);
begin
  inherited;
  ControlDefaultFocus;
end;

procedure TSystemLoginBaseView.LoadLoginInformation;
begin
  LabeledEditUsername.Text := TSessionManager.GetSessionInfo.GetMainAPIMail;
end;

procedure TSystemLoginBaseView.PrepareComponents;
begin
  inherited;
  ButtonLogin.ModalResult := mrNone;
  LabeledEditUsername.Enabled := False;
  AddImagesToADPasswordButtonedEdit(ADPasswordButtonedEdit);
  EnabledComponentes;
  LoadLoginInformation;
end;

procedure TSystemLoginBaseView.PrepareEvents;
begin
  inherited;
  ADPasswordButtonedEdit.OnKeyDown := DoOnKeyDownADPasswordButtonedEdit;
end;

end.
