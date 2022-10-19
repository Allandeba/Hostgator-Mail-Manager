unit uHostgatorMailManagerView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBaseView,
  uFrameworkView, Vcl.StdCtrls, Vcl.ExtCtrls, uADComboBox, Vcl.Mask, uHostgatorMailManagerController,
  uEnums, uADPasswordButtonedEdit;

type
  THostgatorMailManagerView = class(TBaseView)
    ADComboBoxOperation: TADComboBox;
    ADComboBoxUsername: TADComboBox;
    ButtonSend: TButton;
    LabeledEditDomain: TLabeledEdit;
    ADPasswordButtonedEditPassword: TADPasswordButtonedEdit;
    procedure ButtonSendClick(Sender: TObject);
  private
    FHostgatorMailManagerController: THostgatorMailManagerController;
    FUsers: TArray<String>;

    procedure FillOperationComboBox;
    procedure ControlEnabledComponents;
    procedure LoadUsernameComboBox;
    procedure ClearComponentes;
    procedure ValidateInformations;
    procedure SendInformation;
    procedure AskAdminPassword;

    procedure DoOnKeyPressADComboBoxUsername(_Sender: TObject; var _Key: Char);
    procedure DoOnKeyPressADComboBoxOperation(_Sender: TObject; var _Key: Char);
    procedure DoOnChangeADComboBoxOperation(_Sender: TObject);

    function CanEnableButtonSend: Boolean;
    function CanEnableUsername: Boolean;
    function CanEnablePassword: Boolean;
    function CanInsertNewEmail: Boolean;
    function CanDelete: Boolean;
    function HasValidOperation: Boolean;
    function GetHostgatorMainManagerController: THostgatorMailManagerController;
    function GetUsers: TArray<String>;

    property HostgatorMainManagerController: THostgatorMailManagerController read GetHostgatorMainManagerController;
    property Users: TArray<String> read GetUsers;
  protected
    procedure PrepareComponents; override;
    procedure PrepareEvents; override;
  public
    destructor Destroy; override;
  end;

implementation

uses
  uSessionManager, uArrayUtils, uMessages, uFrameworkMessage, System.SysUtils, uStrHelper;

{$R *.dfm}

{ THostgatorMailManagerView }

procedure THostgatorMailManagerView.AskAdminPassword;
begin
  if GetTokenInformation.IsEmpty then
    raise ENotImplemented.Create('THostgatorMailManagerView.AskAdminPassword');
end;

procedure THostgatorMailManagerView.ButtonSendClick(Sender: TObject);
begin
  ValidateInformations;
  SendInformation;
end;

function THostgatorMailManagerView.CanDelete: Boolean;
begin
  Result := TArrayUtils.ContainsValue(ADComboBoxUsername.ComboBox.Text, Users);
end;

function THostgatorMailManagerView.CanEnableButtonSend: Boolean;
begin
  Result := HasValidOperation;
end;

function THostgatorMailManagerView.CanEnablePassword: Boolean;
begin
  Result := HasValidOperation and (ADComboBoxOperation.ComboBox.ItemIndex <> Ord(oDeleteEmail));
end;

function THostgatorMailManagerView.CanEnableUsername: Boolean;
begin
  Result := HasValidOperation;
end;

function THostgatorMailManagerView.CanInsertNewEmail: Boolean;
begin
  Result := ADComboBoxOperation.ComboBox.ItemIndex = Ord(oAddNew);
end;

procedure THostgatorMailManagerView.ClearComponentes;
begin
  ADComboBoxUsername.ComboBox.Clear;
  ADPasswordButtonedEditPassword.Clear;
end;

procedure THostgatorMailManagerView.ControlEnabledComponents;
begin
  LabeledEditDomain.Enabled := False;
  ButtonSend.Enabled := CanEnableButtonSend;
  ADComboBoxUsername.Enabled := CanEnableUsername;
  ADPasswordButtonedEditPassword.Enabled := CanEnablePassword;
end;

destructor THostgatorMailManagerView.Destroy;
begin
  FHostgatorMailManagerController.Free;
  inherited;
end;

procedure THostgatorMailManagerView.DoOnChangeADComboBoxOperation(_Sender: TObject);
var
  AComboBox: TComboBox;
begin
  AComboBox := _Sender as TComboBox;
  ControlEnabledComponents;
  ClearComponentes;

  if TArrayUtils.ContainsValue(AComboBox.ItemIndex, [Ord(oChangePassword), Ord(oDeleteEmail)]) then
    AddNamesValues(ADComboBoxUsername.ComboBox.Items, Users)
  else
    ADComboBoxUsername.ComboBox.Items.Clear;
end;

procedure THostgatorMailManagerView.DoOnKeyPressADComboBoxOperation(_Sender: TObject; var _Key: Char);
begin
  _Key := #0;
end;

procedure THostgatorMailManagerView.DoOnKeyPressADComboBoxUsername(_Sender: TObject; var _Key: Char);
begin
  if not CanInsertNewEmail then
    _Key := #0;
end;

procedure THostgatorMailManagerView.FillOperationComboBox;
begin
  AddNamesValues(ADComboBoxOperation.ComboBox, TOperationValues, True);
end;

function THostgatorMailManagerView.GetHostgatorMainManagerController: THostgatorMailManagerController;
begin
  if FHostgatorMailManagerController = nil then
    FHostgatorMailManagerController := THostgatorMailManagerController.Create;
  Result := FHostgatorMailManagerController;
end;

function THostgatorMailManagerView.GetUsers: TArray<String>;
begin
  if Length(FUsers) = 0 then
    FUsers := HostgatorMainManagerController.GetUsernameList;
  Result := FUsers;
end;

function THostgatorMailManagerView.HasValidOperation: Boolean;
begin
  Result := ADComboBoxOperation.ComboBox.ItemIndex > 0;
end;

procedure THostgatorMailManagerView.LoadUsernameComboBox;
begin
  FUsers := HostgatorMainManagerController.GetUsernameList;
  AddNamesValues(ADComboBoxUsername.ComboBox.Items, FUsers);
end;

procedure THostgatorMailManagerView.PrepareComponents;
begin
  inherited;
  FillOperationComboBox;
  ControlEnabledComponents;
  LoadUsernameComboBox;
  LabeledEditDomain.Text := TSessionManager.GetSessionInfo.Domain;
  AddImagesToADPasswordButtonedEdit(ADPasswordButtonedEditPassword);
end;

procedure THostgatorMailManagerView.PrepareEvents;
begin
  inherited;
  ADComboBoxUsername.OnKeyPress := DoOnKeyPressADComboBoxUsername;
  ADComboBoxOperation.OnChange := DoOnChangeADComboBoxOperation;
  ADComboBoxOperation.OnKeyPress := DoOnKeyPressADComboBoxOperation;
end;

procedure THostgatorMailManagerView.SendInformation;
begin
  if TArrayUtils.ContainsValue(ADComboBoxOperation.ComboBox.ItemIndex,[Ord(oChangePassword), Ord(oDeleteEmail)]) then
  begin
    if HostgatorMainManagerController.IsUserAdmin(ADComboBoxUsername.ComboBox.Text) then
    begin
      TMessageView.New(MSG_0006).Show;
      AskAdminPassword;
    end;
  end;

  case ADComboBoxOperation.ComboBox.ItemIndex of
    Ord(oAddNew):
    begin
      HostgatorMainManagerController.AddNewEmail(ADComboBoxUsername.ComboBox.Text, ADPasswordButtonedEditPassword.Text);
      LoadUsernameComboBox;
    end;

    Ord(oChangePassword):
      HostgatorMainManagerController.ChangePassword(ADComboBoxUsername.ComboBox.Text, ADPasswordButtonedEditPassword.Text);

    Ord(oDeleteEmail):
      HostgatorMainManagerController.DeleteEmail(ADComboBoxUsername.ComboBox.Text);
  end;

  TMessageView.New(MSG_0003).Success.Show;
  ADComboBoxOperation.ComboBox.ItemIndex := 0;
  ClearComponentes;
  ControlEnabledComponents;
end;

procedure THostgatorMailManagerView.ValidateInformations;
var
  AIsUserValid: Boolean;
  AIsPasswordValid: Boolean;
begin
  AIsUserValid := not ADComboBoxUsername.ComboBox.Text.IsEmpty;
  AIsPasswordValid := not ADPasswordButtonedEditPassword.Text.IsEmpty;

  case ADComboBoxOperation.ComboBox.ItemIndex of
    Ord(oAddNew):
    begin
      if not (AIsUserValid and AIsPasswordValid) then
        TMessageView.New(MSG_0001).ShowAndAbort;
    end;

    Ord(oChangePassword):
    begin
      if not (AIsUserValid and AIsPasswordValid) then
        TMessageView.New(MSG_0001).ShowAndAbort;
    end;
    Ord(oDeleteEmail):
    begin
      if not AIsUserValid then
        TMessageView.New(MSG_0001).ShowAndAbort;

      if not CanDelete then
        TMessageView.New(MSG_0007).Error.ShowAndAbort;
    end;
  end;
end;

end.
