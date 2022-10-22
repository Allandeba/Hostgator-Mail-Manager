unit uVersionUpdateController;

interface

type
  TVersionUpdateController = class
  private
    procedure DownloadSystem(_AURLDownloadSystem: String);
    procedure InstallUpdate;

    function GetAPIDownloadFileName: String;
    function GetURLDownloadNewVersion: String;
    function GetURLReleaseVersionArchives: String; overload;
    function GetContentRequest(_Request: String): String;
  public
    procedure UpdateVersion;
    function HasUpdatedVersion: Boolean;
  end;

implementation

uses
  SysUtils, Math, Types, IOUtils, Classes, JSON, ShellAPI, Winapi.Windows, Vcl.Forms, uRequest, uConsts, uSystemInfo, uJSON;

{ TVersionUpdateController }

function TVersionUpdateController.HasUpdatedVersion: Boolean;
var
  AContentRequest: String;
  AVersionRelease: Double;
begin
  AContentRequest := GetContentRequest(GITHUB_PARAM_URL_GET_RELEASES);
  AVersionRelease := TJSONUtils<Double>.Parse(GITHUB_PARAM_ACTUAL_RELEASE_VERSION, AContentRequest, False);

  Result := (CompareValue(AVersionRelease, TSystemInfo.GetClientVersion<Double>)) = GreaterThanValue;
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

function TVersionUpdateController.GetURLReleaseVersionArchives: String;
var
  AContentRequest: String;
begin
  AContentRequest := GetContentRequest(GITHUB_PARAM_URL_GET_RELEASES);
  Result := TJSONUtils<String>.Parse(GITHUB_PARAM_RELEASE_URL, AContentRequest, GITHUB_PARAM_RELEASE_VERSION, False);
end;

function TVersionUpdateController.GetURLDownloadNewVersion: String;
var
  AURLReleaseVersionArchives: String;
  AContentRequest: String;
begin
  AURLReleaseVersionArchives := GetURLReleaseVersionArchives;
  AContentRequest := GetContentRequest(AURLReleaseVersionArchives);

  Result := TJSONUtils<String>.Parse(GITHUB_PARAM_DOWNLOAD_NEW_EXE_VERSION_URL, AContentRequest, False);
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

