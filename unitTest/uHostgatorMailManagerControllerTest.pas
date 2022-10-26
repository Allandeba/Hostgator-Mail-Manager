unit uHostgatorMailManagerControllerTest;

interface

uses
  DUnitX.TestFramework, uHostgatorMailManagerController, uHostgatorMailManager;

const
  TEST_ADMIN_USER = 'api';
  TEST_EMAIL_1 = 'AnyEmail';
  TEST_EMAIL_PASSWORD_1 = 'any_passsword';
  TEST_EMAIL_2 = 'anyOtherUser';
  TEST_EMAIL__PASSWORD_2 = 'any_passsword_changed';

type
  [TestFixture]
  THostgatorMailManagerControllerTest = class
  private
    FHostgatorMailManagerController: THostgatorMailManagerController;
    function GetHostgatorMailManager: THostgatorMailManager;
    function GetHostgatorMailManagerController: THostgatorMailManagerController;
    property HostgatorMailManagerController: THostgatorMailManagerController read GetHostgatorMailManagerController;
  public
    destructor Destroy; override;
    [Test]
    procedure GetUsernameList;
    [Test]
    procedure IsUserAdmin;
    [Test]
    procedure NotIsUserAdmin;
    [Test]
    [TestCase('AddNewEmailTest1', TEST_EMAIL_1)]
    [TestCase('NotIsAdminTest2', TEST_EMAIL_2)]
    procedure AddNewEmail(const _Value: String);
    [Test]
    [TestCase('ChangePasswordTest1', Test_Email_1)]
    [TestCase('ChangePasswordTest2', Test_Email_2)]
    procedure ChangePassword(_Value: string);
    [Test]
    [TestCase('DeleteEmailTest1', TEST_EMAIL_1)]
    [TestCase('DeleteEmailTest2', TEST_EMAIL_2)]
    procedure DeleteEmail(_Value: string);
  end;

implementation

uses
  uUnitTestUtils;

{ THostgatorMailManagerControllerTest }

procedure THostgatorMailManagerControllerTest.AddNewEmail(const _Value: String);
var
  AHostgatorMailManager: THostgatorMailManager;
begin
  AHostgatorMailManager := GetHostgatorMailManager;
  try
    AHostgatorMailManager.Username := _Value;
    AHostgatorMailManager.Password := TEST_EMAIL_PASSWORD_1;
    Assert.WillNotRaise(procedure
                        begin
                          HostgatorMailManagerController.AddNewEmail(AHostgatorMailManager);
                        end);
  finally
    AHostgatorMailManager.Free;
  end;
end;

procedure THostgatorMailManagerControllerTest.ChangePassword(_Value: string);
var
  AHostgatorMailManager: THostgatorMailManager;
begin
  AHostgatorMailManager := GetHostgatorMailManager;
  try
    AHostgatorMailManager.Username := _Value;
    AHostgatorMailManager.Password := TEST_EMAIL__PASSWORD_2;
    Assert.WillNotRaise(procedure
                        begin
                          HostgatorMailManagerController.ChangePassword(AHostgatorMailManager);
                        end);
  finally
    AHostgatorMailManager.Free;
  end;
end;

procedure THostgatorMailManagerControllerTest.DeleteEmail(_Value: string);
var
  AHostgatorMailManager: THostgatorMailManager;
begin
  AHostgatorMailManager := GetHostgatorMailManager;
  try
    AHostgatorMailManager.Username := _Value;
    AHostgatorMailManager.Password := 'any_random_passsword_changed';
    Assert.WillNotRaise(procedure
                        begin
                          HostgatorMailManagerController.DeleteEmail(AHostgatorMailManager);
                        end);
  finally
    AHostgatorMailManager.Free;
  end;
end;

destructor THostgatorMailManagerControllerTest.Destroy;
begin
  FHostgatorMailManagerController.Free;
  inherited;
end;

function THostgatorMailManagerControllerTest.GetHostgatorMailManager: THostgatorMailManager;
begin
  Result := TUnitTestUtils.GetHostgatorMailManagerFromLocalFile;
end;

function THostgatorMailManagerControllerTest.GetHostgatorMailManagerController: THostgatorMailManagerController;
begin
  if FHostgatorMailManagerController = nil then
    FHostgatorMailManagerController := THostgatorMailManagerController.Create;
  Result := FHostgatorMailManagerController;
end;

procedure THostgatorMailManagerControllerTest.GetUsernameList;
var
  AHostgatorMailManager: THostgatorMailManager;
  AUserNameList: TArray<string>;
begin
  AHostgatorMailManager := GetHostgatorMailManager;
  try
    AUserNameList := HostgatorMailManagerController.GetUsernameList(AHostgatorMailManager);
    Assert.AreEqual(AUserNameList[0], TEST_ADMIN_USER);
  finally
    AHostgatorMailManager.Free;
  end;
end;

procedure THostgatorMailManagerControllerTest.IsUserAdmin;
begin
  Assert.IsTrue(HostgatorMailManagerController.IsUserAdmin(TEST_ADMIN_USER));
end;

procedure THostgatorMailManagerControllerTest.NotIsUserAdmin;
begin
  Assert.IsFalse(HostgatorMailManagerController.IsUserAdmin('another_random_user'));
end;

initialization
  TDUnitX.RegisterTestFixture(THostgatorMailManagerControllerTest);

end.
