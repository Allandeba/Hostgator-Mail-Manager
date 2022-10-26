unit uVersionControllerTest;

interface

uses
  DUnitX.TestFramework, uVersionUpdateController;

type
  [TestFixture]
  TVersionControllerTest = class
  private
    FVersionUpdateController: TVersionUpdateController;
    function GetVersionUpdateController: TVersionUpdateController;
    property VersionUpdateController: TVersionUpdateController read GetVersionUpdateController;
  public
    destructor Destroy; override;
    [Test]
    procedure CheckVersionUpdateExistsTest;
    [Test]
    procedure UpdateVersion;
    [Test]
    procedure CheckVersionUpdateNotExistsTest;
  end;

implementation

uses
  uGithubReleases, IdHTTP, IdSSLOpenSSL, uConsts;

procedure TVersionControllerTest.CheckVersionUpdateExistsTest;
const
  DEFAULT_VERSION = '-1.0';
begin
  Assert.IsTrue(VersionUpdateController.HasUpdatedVersion(DEFAULT_VERSION));
end;

procedure TVersionControllerTest.CheckVersionUpdateNotExistsTest;
var
  AGithubReleases: TGitHubReleases;
  AIdHTTP: TIdHTTP;
  AIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
  AVersionRelease: String;
begin
  AGithubReleases := TGithubReleases.Create;
  try
    AIdHTTP := TIdHTTP.Create(nil);
    try
      AIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      try
        AIdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvSSLv23;
        AIdSSLIOHandlerSocketOpenSSL.SSLOptions.SSLVersions := [sslvTLSv1_2, sslvTLSv1_1, sslvTLSv1];
        AIdHTTP.IOHandler := AIdSSLIOHandlerSocketOpenSSL;
        AIdHTTP.HandleRedirects := True;
        AIdHTTP.Request.ContentType := 'text/html';
        AIdHTTP.Request.CharSet := 'UTF-8';
        AIdHTTP.Request.ContentType := 'application/json';

        AGithubReleases.AsJson := AIdHTTP.Get(GITHUB_PARAM_URL_GET_RELEASES);
        AVersionRelease := AGithubReleases.Items.First.TagName;
      finally
        AIdSSLIOHandlerSocketOpenSSL.Free;
      end;
    finally
      AIdHTTP.Free;
    end;
  finally
    AGithubReleases.Free;
  end;

  Assert.IsFalse(VersionUpdateController.HasUpdatedVersion(AVersionRelease));
end;

destructor TVersionControllerTest.Destroy;
begin
  FVersionUpdateController.Free;
  inherited;
end;

function TVersionControllerTest.GetVersionUpdateController: TVersionUpdateController;
begin
  if FVersionUpdateController = nil then
    FVersionUpdateController := TVersionUpdateController.Create;
  Result := FVersionUpdateController;
end;

procedure TVersionControllerTest.UpdateVersion;
begin
  Assert.WillNotRaise(VersionUpdateController.UpdateVersion);
end;

initialization
  TDUnitX.RegisterTestFixture(TVersionControllerTest);

end.
