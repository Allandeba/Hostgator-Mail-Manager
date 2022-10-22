unit uHostgatorMailManagerView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBaseView,
  uFrameworkView, Vcl.StdCtrls, Vcl.ExtCtrls, uADComboBox, Vcl.Mask, uHostgatorMailManagerController,
  uEnums, uADPasswordButtonedEdit;

type
  THostgatorMailManagerView = class(TBaseView)
    FlowPanelButtons: TFlowPanel;
    ButtonSend: TButton;
    FlowPanelOperation: TFlowPanel;
    ADComboBoxOperation: TADComboBox;
    procedure ButtonSendClick(Sender: TObject);
  private
    FFlowPanelComponents: TFlowPanel;
    FADComboBoxUsername: TADComboBox;
    FLabeledEditDomain: TLabeledEdit;
    FLabeledEditUsername: TLabeledEdit;
    FADPasswordButtonedEdit: TADPasswordButtonedEdit;
    FHostgatorMailManagerController: THostgatorMailManagerController;
    FUsers: TArray<String>;

    procedure FillOperationComboBox;
    procedure LoadUsernameComboBox;
    procedure ValidateInformations;
    procedure SendInformation;
    procedure AskAdminPassword;
    procedure ValidateAdministratorChanging;
    procedure ClearComponents;
    procedure CreateFlowPanel;
    procedure CreateComponentAddNewEmail;
    procedure CreateComponentChangePassword;
    procedure CreateComponentDeleteEmail;
    procedure CreateUsername;
    procedure CreateComboBoxUsername;
    procedure CreateDomain;
    procedure CreatePassword;
    procedure ResizeScreen(_Operation: TOperation);
    procedure ControlButtonSend(_Operation: TOperation);

    procedure DoOnKeyPressADComboBoxUsername(_Sender: TObject; var _Key: Char);
    procedure DoOnKeyPressADComboBoxOperation(_Sender: TObject; var _Key: Char);
    procedure DoOnChangeADComboBoxOperation(_Sender: TObject);

    function CanInsertNewEmail: Boolean;
    function CanDelete: Boolean;
    function GetHostgatorMainManagerController: THostgatorMailManagerController;
    function GetUsers: TArray<String>;
    function GetPasswordWidth: Integer;
    function GetPasswordTop: Integer;
    function GetDomainLeft: Integer;
    function IsUserValid: Boolean;
    function IsPasswordValid: Boolean;
    function GetUsername: String;

    property HostgatorMainManagerController: THostgatorMailManagerController read GetHostgatorMainManagerController;
    property Users: TArray<String> read GetUsers;
  protected
    procedure PrepareComponents; override;
    procedure PrepareEvents; override;
  public
    destructor Destroy; override;
  end;

const
  COMPONENT_TOP = 5;
  COMPONENT_LEFT = 20;
  COMPONENT_HEIGHT = 23;
  COMPONENT_WIDTH = 109;
  COMPONENT_PADDING = 5;
  COMPONENT_ANCHORS = [];

  DEFAULT_SCREEN_SIZE_HEIGHT = 135;
  DEFAULT_PANEL_COMPONENTS_HEIGHT = 100;

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
  Result := TArrayUtils.ContainsValue(FADComboBoxUsername.Text, Users);
end;

function THostgatorMailManagerView.CanInsertNewEmail: Boolean;
begin
  Result := ADComboBoxOperation.ItemIndex = Ord(oAddNew);
end;

procedure THostgatorMailManagerView.ClearComponents;
begin
  FreeAndNil(FADComboBoxUsername);
  FreeAndNil(FLabeledEditUsername);
  FreeAndNil(FADPasswordButtonedEdit);
  FreeAndNil(FLabeledEditDomain);
  FreeAndNil(FFLowPanelComponents);
end;

procedure THostgatorMailManagerView.ControlButtonSend(_Operation: TOperation);
begin
  ButtonSend.Enabled := _Operation <> oNone;
end;

procedure THostgatorMailManagerView.CreateComboBoxUsername;
begin
  FADComboBoxUsername := TADComboBox.Create(Self);
  FADComboBoxUsername.Parent := FFlowPanelComponents;
  FADComboBoxUsername.AlignWithMargins := True;
  FADComboBoxUsername.Left := COMPONENT_LEFT;
  FADComboBoxUsername.Top := 0;
  FADComboBoxUsername.Width := COMPONENT_WIDTH;
  FADComboBoxUsername.Height := 43;
  FADComboBoxUsername.Anchors := COMPONENT_ANCHORS;
  FADComboBoxUsername.BevelOuter := bvNone;
  FADComboBoxUsername.TabOrder := 1;
  FADComboBoxUsername.LabelCaption := 'Username';

  AddNamesValues(FADComboBoxUsername.Items, Users);
  FADComboBoxUsername.OnKeyPress := DoOnKeyPressADComboBoxUsername;
end;

procedure THostgatorMailManagerView.CreateComponentAddNewEmail;
begin
  ClearComponents;
  CreateFlowPanel;
  CreateUsername;
  CreateDomain;
  CreatePassword;
end;

procedure THostgatorMailManagerView.CreateComponentChangePassword;
begin
  ClearComponents;
  CreateFlowPanel;
  CreateComboBoxUsername;
  CreateDomain;
  CreatePassword;
end;

procedure THostgatorMailManagerView.CreateComponentDeleteEmail;
begin
  ClearComponents;
  CreateFlowPanel;
  CreateComboBoxUsername;
  CreateDomain;
end;

procedure THostgatorMailManagerView.CreateDomain;
begin
  FLabeledEditDomain := TLabeledEdit.Create(Self);
  FLabeledEditDomain.Parent := FFlowPanelComponents;
  FLabeledEditDomain.AlignWithMargins := True;
  FLabeledEditDomain.Left := GetDomainLeft;
  FLabeledEditDomain.Top := COMPONENT_TOP;
  FLabeledEditDomain.Width := COMPONENT_WIDTH;
  FLabeledEditDomain.Height := COMPONENT_HEIGHT;
  FLabeledEditDomain.Anchors := COMPONENT_ANCHORS;
  FLabeledEditDomain.AutoSize := False;
  FLabeledEditDomain.EditLabel.Width := Trunc(FLabeledEditDomain.Width / 2);
  FLabeledEditDomain.EditLabel.Height := 15;
  FLabeledEditDomain.TabOrder := 2;
  FLabeledEditDomain.Text := TSessionManager.GetSessionInfo.Domain;
  FLabeledEditDomain.EditLabel.Caption := 'Domain';
  FLabeledEditDomain.Enabled := False;
end;

procedure THostgatorMailManagerView.CreateFlowPanel;
begin
  FFlowPanelComponents := TFlowPanel.Create(Self);
  FFlowPanelComponents.Parent := Self;
  FFlowPanelComponents.Height := DEFAULT_PANEL_COMPONENTS_HEIGHT;
  FFlowPanelComponents.Align := alClient;
  FFlowPanelComponents.AlignWithMargins := True;
  FFlowPanelComponents.ShowCaption := False;
  FFlowPanelComponents.BorderStyle := bsNone;
  FFlowPanelComponents.BevelOuter := bvNone;
  FFlowPanelComponents.Anchors := [];
  FFlowPanelComponents.UseDockManager := False;
  FFlowPanelComponents.FlowStyle := fsLeftRightTopBottom;
  FFlowPanelComponents.FullRepaint := True;
  FFlowPanelComponents.Padding.Left := 8;
  FFlowPanelComponents.TabOrder := 1;
end;

procedure THostgatorMailManagerView.CreatePassword;
begin
  FADPasswordButtonedEdit := TADPasswordButtonedEdit.Create(Self);
  FADPasswordButtonedEdit.Parent := FFlowPanelComponents;
  FADPasswordButtonedEdit.AlignWithMargins := True;
  FADPasswordButtonedEdit.Left := COMPONENT_LEFT;
  FADPasswordButtonedEdit.Top := GetPasswordTop;
  FADPasswordButtonedEdit.Width := GetPasswordWidth;
  FADPasswordButtonedEdit.Anchors := COMPONENT_ANCHORS;
  FADPasswordButtonedEdit.UseDockManager := False;
  FADPasswordButtonedEdit.TabOrder := 3;
  FADPasswordButtonedEdit.LabelCaption := 'Password';
  FADPasswordButtonedEdit.Text := '';

  AddImagesToADPasswordButtonedEdit(FADPasswordButtonedEdit);
end;

procedure THostgatorMailManagerView.CreateUsername;
begin
  FLabeledEditUsername := TLabeledEdit.Create(Self);
  FLabeledEditUsername.Parent := FFlowPanelComponents;
  FLabeledEditUsername.AlignWithMargins := True;
  FLabeledEditUsername.Left := COMPONENT_LEFT;
  FLabeledEditUsername.Top := COMPONENT_TOP;
  FLabeledEditUsername.Width := COMPONENT_WIDTH;
  FLabeledEditUsername.Height := COMPONENT_HEIGHT;
  FLabeledEditUsername.Anchors := COMPONENT_ANCHORS;
  FLabeledEditUsername.AutoSize := False;
  FLabeledEditUsername.EditLabel.Width := Trunc(FLabeledEditUsername.Width / 2);
  FLabeledEditUsername.EditLabel.Height := 15;
  FLabeledEditUsername.EditLabel.Caption := 'Username';
  FLabeledEditUsername.TabOrder := 1;
  FLabeledEditUsername.Text := '';
end;

destructor THostgatorMailManagerView.Destroy;
begin
  FHostgatorMailManagerController.Free;
  inherited;
end;

procedure THostgatorMailManagerView.DoOnChangeADComboBoxOperation(_Sender: TObject);
begin
  FlowPanelOperation.LockDrawing;
  try
    case ADComboBoxOperation.ItemIndex of
      0: ClearComponents;
      1: CreateComponentAddNewEmail;
      2: CreateComponentChangePassword;
      3: CreateComponentDeleteEmail;
    end;

    ControlButtonSend(TOperation(ADComboBoxOperation.ItemIndex));
    ResizeScreen(TOperation(ADComboBoxOperation.ItemIndex));
  finally
    FlowPanelOperation.UnlockDrawing;
  end;
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
  AddNamesValues(ADComboBoxOperation, TOperationValues, True);
end;

function THostgatorMailManagerView.GetDomainLeft: Integer;
begin
  Result := COMPONENT_LEFT;
  if FADComboBoxUsername <> nil then
    Result := Result + FADComboBoxUsername.Left + FADComboBoxUsername.Width;
  if FLabeledEditUsername <> nil then
    Result := Result + FLabeledEditUsername.Left + FLabeledEditUsername.Width;
end;

function THostgatorMailManagerView.GetHostgatorMainManagerController: THostgatorMailManagerController;
begin
  if FHostgatorMailManagerController = nil then
    FHostgatorMailManagerController := THostgatorMailManagerController.Create;
  Result := FHostgatorMailManagerController;
end;

function THostgatorMailManagerView.GetPasswordTop: Integer;
begin
  Result := COMPONENT_PADDING;
  if FADComboBoxUsername <> nil then
    Result := Result + FADComboBoxUsername.Top + FADComboBoxUsername.Height;
  if FLabeledEditUsername <> nil then
    Result := Result + FLabeledEditUsername.Top + FLabeledEditUsername.Height;
end;

function THostgatorMailManagerView.GetPasswordWidth: Integer;
begin
  Result := COMPONENT_PADDING;
  if FADComboBoxUsername <> nil then
    Result := Result + FADComboBoxUsername.Width;
  if FLabeledEditUsername <> nil then
    Result := Result + FLabeledEditUsername.Width;
  if FLabeledEditDomain <> nil then
    Result := Result + FLabeledEditDomain.Width;
end;

function THostgatorMailManagerView.GetUsername: String;
begin
  Result := '';
  if FADComboBoxUsername <> nil then
    Result := FADComboBoxUsername.ComboBox.Text;
  if FLabeledEditUsername <> nil then
    Result := FLabeledEditUsername.Text;
end;

function THostgatorMailManagerView.GetUsers: TArray<String>;
begin
  if Length(FUsers) = 0 then
    FUsers := HostgatorMainManagerController.GetUsernameList;
  Result := FUsers;
end;

function THostgatorMailManagerView.IsPasswordValid: Boolean;
begin
  Result := not FADPasswordButtonedEdit.Text.IsEmpty;
end;

function THostgatorMailManagerView.IsUserValid: Boolean;
begin
  Result := False;
  if FADComboBoxUsername <> nil then
    Result := not FADComboBoxUsername.ComboBox.Text.IsEmpty;
  if FLabeledEditUsername <> nil then
    Result := not FLabeledEditUsername.Text.IsEmpty;
end;

procedure THostgatorMailManagerView.LoadUsernameComboBox;
begin
  FUsers := HostgatorMainManagerController.GetUsernameList;
end;

procedure THostgatorMailManagerView.PrepareComponents;
begin
  inherited;
  FillOperationComboBox;
  LoadUsernameComboBox;
  ResizeScreen(oNone);
  ControlButtonSend(oNone);
end;

procedure THostgatorMailManagerView.PrepareEvents;
begin
  inherited;
  ADComboBoxOperation.OnChange := DoOnChangeADComboBoxOperation;
  ADComboBoxOperation.OnKeyPress := DoOnKeyPressADComboBoxOperation;
end;

procedure THostgatorMailManagerView.ResizeScreen(_Operation: TOperation);
const
  ADPASSWORD_BUTTONED_EDIT_HEIGHT = 40;
begin
  case _Operation of
    oNone:
      Height := DEFAULT_SCREEN_SIZE_HEIGHT;
    oAddNew:
      Height := DEFAULT_SCREEN_SIZE_HEIGHT + DEFAULT_PANEL_COMPONENTS_HEIGHT;
    oChangePassword:
      Height := DEFAULT_SCREEN_SIZE_HEIGHT + DEFAULT_PANEL_COMPONENTS_HEIGHT;
    oDeleteEmail:
      Height := DEFAULT_SCREEN_SIZE_HEIGHT + DEFAULT_PANEL_COMPONENTS_HEIGHT - ADPASSWORD_BUTTONED_EDIT_HEIGHT;
  else
    raise ENotImplemented.Create('_Operation not implemented!' + sLineBreak + 'THostgatorMailManagerView.ResizeScreen');
  end;
end;

procedure THostgatorMailManagerView.SendInformation;
begin
  ValidateAdministratorChanging;

  case ADComboBoxOperation.ComboBox.ItemIndex of
    Ord(oAddNew):
    begin
      HostgatorMainManagerController.AddNewEmail(GetUsername, FADPasswordButtonedEdit.Text);
      LoadUsernameComboBox;
    end;

    Ord(oChangePassword):
      HostgatorMainManagerController.ChangePassword(GetUsername, FADPasswordButtonedEdit.Text);

    Ord(oDeleteEmail):
      HostgatorMainManagerController.DeleteEmail(GetUsername);
  end;

  TMessageView.New(MSG_0003).Success.Show;
  ADComboBoxOperation.ComboBox.ItemIndex := 0;
  ResizeScreen(oNone);
  ClearComponents;
end;

procedure THostgatorMailManagerView.ValidateAdministratorChanging;
begin
  if HostgatorMainManagerController.IsUserAdmin(GetUsername) then
  begin
    if ADComboBoxOperation.ComboBox.ItemIndex = Ord(oDeleteEmail) then
      TMessageView.New(MSG_0015).ShowAndAbort;

    if ADComboBoxOperation.ComboBox.ItemIndex = Ord(oChangePassword) then
    begin
      TMessageView.New(MSG_0006).Show;
      AskAdminPassword;
    end;
  end;
end;

procedure THostgatorMailManagerView.ValidateInformations;
begin
  case ADComboBoxOperation.ComboBox.ItemIndex of
    Ord(oAddNew):
    begin
      if not (IsUserValid and IsPasswordValid) then
        TMessageView.New(MSG_0001).ShowAndAbort;
    end;

    Ord(oChangePassword):
    begin
      if not (IsUserValid and IsPasswordValid) then
        TMessageView.New(MSG_0001).ShowAndAbort;
    end;
    Ord(oDeleteEmail):
    begin
      if not IsUserValid then
        TMessageView.New(MSG_0001).ShowAndAbort;

      if not CanDelete then
        TMessageView.New(MSG_0007).Error.ShowAndAbort;
    end;
  end;
end;

end.
