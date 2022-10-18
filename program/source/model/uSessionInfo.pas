unit uSessionInfo;

interface

type

  TSessionInfo = class
  private
    FTemporaryToken: String;
    FDomain: String;
    FMainEmailUsername: String;
    FHostgatorUsername: String;
    FHostgatorDNS: String;
  public
    function GetMainAPIMail: String;

    property Token: String read FTemporaryToken write FTemporaryToken;
    property Domain: String read FDomain write FDomain;
    property MainEmailUsername: String read FMainEmailUsername write FMainEmailUsername;
    property HostgatorUsername: String read FHostgatorUsername write FHostgatorUsername;
    property HostgatorHostIP: String read FHostgatorDNS write FHostgatorDNS;
  end;

implementation

uses
  System.SysUtils;

{ TSessionInfo }

function TSessionInfo.GetMainAPIMail: String;
begin
  if FMainEmailUsername.IsEmpty or FDomain.IsEmpty then
    Exit(EmptyStr);

  Result := Format('%s@%s', [FMainEmailUsername, FDomain]);
end;

end.
