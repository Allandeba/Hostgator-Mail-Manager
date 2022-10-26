unit uVersionUpdateController;

interface

type
  TVersionControl = (vcNone, vcMajor, vcMinor, vcPatch);

  TVersionUpdateController = class
  private
    procedure DownloadSystem(_AURLDownloadSystem: String);
    procedure InstallUpdate;

    function GetAPIDownloadFileName: String;
    function GetURLDownloadNewVersion: String;
    function GetContentRequest(_Request: String): String;
    function GetVersion(_Version: String; _VersionControl: TVersionControl): Integer;
  public
    procedure UpdateVersion;
    function HasUpdatedVersion(_LocalVersion: String): Boolean;
  end;

implementation

uses
  SysUtils, Types, IOUtils, Classes, ShellAPI, Winapi.Windows, Vcl.Forms, uRequest, uConsts, uGithubReleases;

{ TVersionUpdateController }

function TVersionUpdateController.GetVersion(_Version: String; _VersionControl: TVersionControl): Integer;
const
  DOT = '.';
var
  I: Integer;
  ACountDot: Integer;
  ALastVersionPoint: Integer;
begin
  Result := 0;
  ACountDot := 0;
  ALastVersionPoint := 0;

  for I := 1 to Length(_Version) do
  begin
    if _Version[I] = DOT then
    begin
      Inc(ACountDot);

      case _VersionControl of
        vcMajor:
        begin
          if ACountDot = Ord(vcMajor) then
            Exit(_Version.Substring(0, I - 1).ToInteger);
        end;

        vcMinor:
        begin
          if ACountDot = Ord(vcMinor) then
            Exit(_Version.Substring(ALastVersionPoint + 1, I - 1).ToInteger);
        end;

        vcPatch:
        begin
          if ACountDot = Ord(vcPatch) then
            Exit(_Version.Substring(ALastVersionPoint + 1, I - 1).ToInteger);
        end;
      else
        raise ENotImplemented.Create('Not implemented...');
      end;

      ALastVersionPoint := I;
    end;
  end;
end;

function TVersionUpdateController.HasUpdatedVersion(_LocalVersion: String): Boolean;
var
  AGithubReleases: TGithubReleases;
  AVersionRelease: String;
  AHasMajorUpdate: Boolean;
  AHasMinorUpdate: Boolean;
  AHasPatchUpdate: Boolean;
begin
  AGithubReleases := TGithubReleases.Create;
  try
    AGithubReleases.AsJson := GetContentRequest(GITHUB_PARAM_URL_GET_RELEASES);
    AVersionRelease := AGithubReleases.Items.First.TagName;
  finally
    AGithubReleases.Free;
  end;

  AHasMajorUpdate := GetVersion(AVersionRelease, vcMajor) > GetVersion(_LocalVersion, vcMajor);
  AHasMinorUpdate := GetVersion(AVersionRelease, vcMinor) > GetVersion(_LocalVersion, vcMinor);
  AHasPatchUpdate := GetVersion(AVersionRelease, vcPatch) > GetVersion(_LocalVersion, vcPatch);
  Result := AHasMajorUpdate or AHasMinorUpdate or AHasPatchUpdate;
end;

procedure TVersionUpdateController.DownloadSystem(_AURLDownloadSystem: String);
var
  AFileStream: TFileStream;
  ARequest: IRequest<TFileStream>;
begin
  AFileStream := TFileStream.Create(GetAPIDownloadFileName, fmCreate);
  try
    ARequest := TRequest<TFileStream>.Create;
    try
      ARequest
        .New(_AURLDownloadSystem)
          .DoRequest(AFileStream);
    except
      raise;
    end;
  finally
    AFileStream.Free;
  end;
end;

procedure TVersionUpdateController.InstallUpdate;
begin
  ShellExecute(Application.Handle, 'open', PChar(GetAPIDownloadFileName), '', '', SW_SHOWNORMAL);
  Application.Terminate;
end;

function TVersionUpdateController.GetAPIDownloadFileName: String;
begin
  Result := Format('%s\%s', [TPath.GetDownloadsPath, SYSTEM_NAME + SYSTEM_EXTENSION]);
end;

function TVersionUpdateController.GetContentRequest(_Request: String): String;
var
  ARequest: IRequest<String>;
begin
  ARequest := TRequest<String>.Create;
  try
    Result :=
      ARequest
        .New(_Request)
          .DoRequest;
  except
    raise;
  end;
end;

function TVersionUpdateController.GetURLDownloadNewVersion: String;
var
  AGithubReleases: TGithubReleases;
begin
  AGithubReleases := TGithubReleases.Create;
  try
    AGithubReleases.AsJson := GetContentRequest(GITHUB_PARAM_URL_GET_RELEASES);
    Result := AGithubReleases.Items.First.Assets.First.BrowserDownloadUrl;
  finally
    AGithubReleases.Free;
  end;
end;

procedure TVersionUpdateController.UpdateVersion;
var
  AURLDownloadNewVersion: String;
begin
  AURLDownloadNewVersion := GetURLDownloadNewVersion;
  DownloadSystem(AURLDownloadNewVersion);

  InstallUpdate;
end;

end.

