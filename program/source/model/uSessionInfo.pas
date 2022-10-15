unit uSessionInfo;

interface

type

  TSessionInfo = class
  private
    FToken: String;
    FDomain: String;
    FMainUsername: String;
  public
    function GetMainAPIMail: String;

    property Token: String read FToken write FToken;
    property Domain: String read FDomain write FDomain;
    property MainUsername: String read FMainUsername write FMainUsername;
  end;

implementation

uses
  System.SysUtils;

{ TSessionInfo }

function TSessionInfo.GetMainAPIMail: String;
begin
  if FMainUsername.IsEmpty or FDomain.IsEmpty then
    Exit(EmptyStr);

  Result := Format('%s@%s', [FMainUsername, FDomain]);
end;

end.
