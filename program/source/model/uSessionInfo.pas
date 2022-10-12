unit uSessionInfo;

interface

type

  TSessionInfo = class
  strict private
    FToken: String;
    FDomain: String;
    FPassword: String;
    FMainAPIMail: String;
  public
    property Token: String read FToken write FToken;
    property Domain: String read FDomain write FDomain;
    property Password: String read FPassword write FPassword;
    property MainAPIMail: String read FMainAPIMail write FMainAPIMail;
  end;

implementation

end.
