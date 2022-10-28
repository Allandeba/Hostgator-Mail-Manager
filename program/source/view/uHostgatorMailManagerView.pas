unit uHostgatorMailManagerView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBaseView, uFrameworkView, Vcl.StdCtrls,
  Vcl.ExtCtrls, uADComboBox, Vcl.Mask, uHostgatorMailManagerController, uEnums, uADPasswordButtonedEdit, uHostgatorMailManager, VCLTee.TeeProcs, uADCustomPanelNoCaption,
  uADLabeledEdit, Vcl.Buttons;

type
  THostgatorMailManagerView = class(TBaseView)
    FlowPanelButtons: TFlowPanel;
    FlowPanelOperation: TFlowPanel;
    ADComboBoxOperation: TADComboBox;
    ButtonSend: TButton;
    procedure ButtonSendClick(Sender: TObject);
  private
    FFlowPanelComponents: TFlowPanel;
    FADComboBoxUsername: TADComboBox;
    FADLabeledEditDomain: TADLabeledEdit;
    FADLabeledEditUsername: TADLabeledEdit;
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
    procedure CreateFlowPanelComponents;
    procedure CreateComponentAddNewEmail;
    procedure CreateComponentChangePassword;
    procedure CreateComponentDeleteEmail;
    procedure CreateUsername;
    procedure CreateComboBoxUsername;
    procedure CreateDomain;
    procedure CreatePassword;
    procedure ResizeScreen(_Operation: TOperation);
    procedure ControlButtonSend(_Operation: TOperation);
    procedure ResetOperation;

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
    function GetPassword: String;
    function GetHostgatorMailManager: THostgatorMailManager;

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
  COMPONENT_WIDTH = 108;
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
    Abort;
end;

procedure THostgatorMailManagerView.ButtonSendClick(Sender: TObject);
begin
  Repaint; // Todo: It needs to be repainted every OnClick with mouse click because it loses the style.
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
  FreeAndNil(FADLabeledEditUsername);
  FreeAndNil(FADPasswordButtonedEdit);
  FreeAndNil(FADLabeledEditDomain);
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
  FADComboBoxUsername.Top := COMPONENT_TOP;
  FADComboBoxUsername.Width := COMPONENT_WIDTH;
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
  CreateFlowPanelComponents;
  CreateUsername;
  CreateDomain;
  CreatePassword;
end;

procedure THostgatorMailManagerView.CreateComponentChangePassword;
begin
  ClearComponents;
  CreateFlowPanelComponents;
  CreateComboBoxUsername;
  CreateDomain;
  CreatePassword;
end;

procedure THostgatorMailManagerView.CreateComponentDeleteEmail;
begin
  ClearComponents;
  CreateFlowPanelComponents;
  CreateComboBoxUsername;
  CreateDomain;
end;

procedure THostgatorMailManagerView.CreateDomain;
begin
  FADLabeledEditDomain := TADLabeledEdit.Create(Self);
  FADLabeledEditDomain.Parent := FFlowPanelComponents;
  FADLabeledEditDomain.AlignWithMargins := True;
  FADLabeledEditDomain.Left := GetDomainLeft;
  FADLabeledEditDomain.Top := COMPONENT_TOP;
  FADLabeledEditDomain.Width := COMPONENT_WIDTH;
  FADLabeledEditDomain.Anchors := COMPONENT_ANCHORS;
  FADLabeledEditDomain.TabOrder := 2;
  FADLabeledEditDomain.LabelCaption := 'Domain';
  FADLabeledEditDomain.Text := TSessionManager.GetSessionInfo.Domain;
  FADLabeledEditDomain.Enabled := False;
end;

procedure THostgatorMailManagerView.CreateFlowPanelComponents;
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
  FFlowPanelComponents.UseDockManager := True;
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
  FADPasswordButtonedEdit.TabOrder := 3;
  FADPasswordButtonedEdit.LabelCaption := 'Password';
  FADPasswordButtonedEdit.Text := '';

  AddImagesToADPasswordButtonedEdit(FADPasswordButtonedEdit);
end;

procedure THostgatorMailManagerView.CreateUsername;
begin
  FADLabeledEditUsername := TADLabeledEdit.Create(Self);
  FADLabeledEditUsername.Parent := FFlowPanelComponents;
  FADLabeledEditUsername.AlignWithMargins := True;
  FADLabeledEditUsername.Left := COMPONENT_LEFT;
  FADLabeledEditUsername.Top := COMPONENT_TOP;
  FADLabeledEditUsername.Width := COMPONENT_WIDTH;
  FADLabeledEditUsername.Anchors := COMPONENT_ANCHORS;
  FADLabeledEditUsername.LabelCaption := 'Username';
  FADLabeledEditUsername.TabOrder := 1;
  FADLabeledEditUsername.Text := '';
end;

destructor THostgatorMailManagerView.Destroy;
begin
  FHostgatorMailManagerController.Free;
  inherited;
end;

procedure THostgatorMailManagerView.DoOnChangeADComboBoxOperation(_Sender: TObject);
begin
  case ADComboBoxOperation.ItemIndex of
    0: ClearComponents;
    1: CreateComponentAddNewEmail;
    2: CreateComponentChangePassword;
    3: CreateComponentDeleteEmail;
  end;

  ControlButtonSend(TOperation(ADComboBoxOperation.ItemIndex));
  ResizeScreen(TOperation(ADComboBoxOperation.ItemIndex));
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
  if FADLabeledEditUsername <> nil then
    Result := Result + FADLabeledEditUsername.Left + FADLabeledEditUsername.Width;
end;

function THostgatorMailManagerView.GetHostgatorMailManager: THostgatorMailManager;
begin
  Result := THostgatorMailManager.Create;
  try
    Result.Email := TSessionManager.GetSessionInfo.GetMainAPIMail;
    Result.Username := GetUsername;
    Result.Domain := TSessionManager.GetSessionInfo.Domain;
    Result.Password := GetPassword;
    Result.Token := TSessionManager.GetSessionInfo.Token;
    Result.HostgatorIP := TSessionManager.GetSessionInfo.HostgatorHostIP;
    Result.HostgatorUsername := TSessionManager.GetSessionInfo.HostgatorUsername;
  except
    Result.Free;
    raise;
  end;
end;

function THostgatorMailManagerView.GetHostgatorMainManagerController: THostgatorMailManagerController;
begin
  if FHostgatorMailManagerController = nil then
    FHostgatorMailManagerController := THostgatorMailManagerController.Create;
  Result := FHostgatorMailManagerController;
end;

function THostgatorMailManagerView.GetPassword: String;
begin
  Result := '';
  if FADPasswordButtonedEdit <> nil then
    Result := FADPasswordButtonedEdit.Text;
end;

function THostgatorMailManagerView.GetPasswordTop: Integer;
begin
  Result := COMPONENT_PADDING;
  if FADComboBoxUsername <> nil then
    Result := Result + FADComboBoxUsername.Top + FADComboBoxUsername.Height;
  if FADLabeledEditUsername <> nil then
    Result := Result + FADLabeledEditUsername.Top + FADLabeledEditUsername.Height;
end;

function THostgatorMailManagerView.GetPasswordWidth: Integer;
begin
  Result := COMPONENT_PADDING;
  if FADComboBoxUsername <> nil then
    Result := Result + FADComboBoxUsername.Width;
  if FADLabeledEditUsername <> nil then
    Result := Result + FADLabeledEditUsername.Width;
  if FADLabeledEditDomain <> nil then
    Result := Result + FADLabeledEditDomain.Width;
end;

function THostgatorMailManagerView.GetUsername: String;
begin
  Result := '';
  if FADComboBoxUsername <> nil then
    Result := FADComboBoxUsername.Text;
  if FADLabeledEditUsername <> nil then
    Result := FADLabeledEditUsername.Text;
end;

function THostgatorMailManagerView.GetUsers: TArray<String>;
var
  AHostgatorMailManager: THostgatorMailManager;
begin
  if Length(FUsers) = 0 then
  begin
    AHostgatorMailManager := GetHostgatorMailManager;
    try
      FUsers := HostgatorMainManagerController.GetUsernameList(AHostgatorMailManager);
    finally
      AHostgatorMailManager.Free;
    end;
  end;

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
    Result := not FADComboBoxUsername.Text.IsEmpty;
  if FADLabeledEditUsername <> nil then
    Result := not FADLabeledEditUsername.Text.IsEmpty;
end;

procedure THostgatorMailManagerView.LoadUsernameComboBox;
var
  AHostgatorMailManager: THostgatorMailManager;
begin
  AHostgatorMailManager := GetHostgatorMailManager;
  try
    FUsers := HostgatorMainManagerController.GetUsernameList(AHostgatorMailManager);
  finally
    AHostgatorMailManager.Free;
  end;
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

procedure THostgatorMailManagerView.ResetOperation;
begin
  ADComboBoxOperation.ItemIndex := Ord(oNone);
  ControlButtonSend(oNone);
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
var
  AHostgatorMailManager: THostgatorMailManager;
begin
  ValidateAdministratorChanging;

  AHostgatorMailManager := GetHostgatorMailManager;
  try
    case ADComboBoxOperation.ItemIndex of
      Ord(oAddNew):
      begin
        HostgatorMainManagerController.AddNewEmail(AHostgatorMailManager);
        LoadUsernameComboBox;
      end;

      Ord(oChangePassword):
        HostgatorMainManagerController.ChangePassword(AHostgatorMailManager);

      Ord(oDeleteEmail):
      begin
        HostgatorMainManagerController.DeleteEmail(AHostgatorMailManager);
        LoadUsernameComboBox;
      end;
    end;
  finally
    AHostgatorMailManager.Free;
  end;

  TMessageView.New(MSG_0003).Success.Show;
  ResetOperation;
  ResizeScreen(oNone);
  ClearComponents;
end;

procedure THostgatorMailManagerView.ValidateAdministratorChanging;
begin
  if HostgatorMainManagerController.IsUserAdmin(GetUsername) then
  begin
    if ADComboBoxOperation.ItemIndex = Ord(oDeleteEmail) then
      TMessageView.New(MSG_0015).ShowAndAbort;

    if ADComboBoxOperation.ItemIndex = Ord(oChangePassword) then
    begin
      TMessageView.New(MSG_0006).Show;
      AskAdminPassword;
    end;
  end;
end;

procedure THostgatorMailManagerView.ValidateInformations;
begin
  case ADComboBoxOperation.ItemIndex of
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
