unit uLoginControllerTest;

interface

uses
  DUnitX.TestFramework, uLoginController, uLogin;

type
  [TestFixture]
  THostgatorMailManagerTest = class
  private
    FLoginController: TLoginController;
    function GetLoginController: TLoginController;
    function GetLogin: TLogin;
    property LoginController: TLoginController read GetLoginController;
  public
    destructor Destroy; override;
    [Test]
    procedure ValidateLoginOK;
    [Test]
    procedure ValidateLoginError;
    [Test]
    procedure SaveLogin;
    procedure UpdateTestInformationToLocalFile(_Login: TLogin);
  end;

implementation

uses
  System.Classes, System.SysUtils, uConsts, uMessages, uUnitTestUtils;

destructor THostgatorMailManagerTest.Destroy;
begin
  FLoginController.Free;
  inherited;
end;

function THostgatorMailManagerTest.GetLogin: TLogin;
begin
  Result := TUnitTestUtils.GetLoginFromLocalFile;
end;

function THostgatorMailManagerTest.GetLoginController: TLoginController;
begin
  if FLoginController = nil then
    FLoginController := TLoginController.Create;
  Result := FLoginController;
end;

procedure THostgatorMailManagerTest.SaveLogin;
var
  ALogin: TLogin;
begin
  ALogin := GetLogin;
  try
    Assert.WillNotRaise(procedure
                        begin
                          LoginController.SaveLoginInformation(ALogin)
                        end);

    UpdateTestInformationToLocalFile(ALogin);
  finally
    ALogin.Free;
  end;
end;

procedure THostgatorMailManagerTest.ValidateLoginError;
var
  ALogin: TLogin;
  AWrongPassword: String;
begin
  ALogin := GetLogin;
  try
    AWrongPassword := '5yH!$lrH529h';
    if AWrongPassword = ALogin.Password then
      AWrongPassword := AWrongPassword + ']';

    ALogin.Password := AWrongPassword;
    Assert.WillRaiseWithMessage(procedure
                                begin
                                  LoginController.ValidateLogin(ALogin);
                                end, nil, MSG_0004);
  finally
    ALogin.Free;
  end;
end;

procedure THostgatorMailManagerTest.UpdateTestInformationToLocalFile(_Login: TLogin);
begin
  TUnitTestUtils.UpdateTestInformationToLocalFile(_Login);
end;

procedure THostgatorMailManagerTest.ValidateLoginOK;
var
  ALogin: TLogin;
begin
  ALogin := GetLogin;
  try
    Assert.WillNotRaise(procedure
                        begin
                          LoginController.ValidateLogin(ALogin);
                        end);
  finally
    ALogin.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(THostgatorMailManagerTest);
end.
