unit uLogin;

interface

type
  TLogin = class
  private
    FMainEmailUsername: String;
    FMainAPIUsername: String;
    FHostgatorUsername: String;
    FDomain: String;
    FHostgatorHostIP: String;
    FPassword: String;
    FToken: String;
  public
    property MainEmailAPI: String read FMainEmailUsername write FMainEmailUsername;
    property MainAPIUsername: String read FMainAPIUsername write FMainAPIUsername;
    property HostgatorUsername: String read FHostgatorUsername write FHostgatorUsername;
    property Domain: String read FDomain write FDomain;
    property HostgatorHostIP: String read FHostgatorHostIP write FHostgatorHostIP;
    property Password: String read FPassword write FPassword;
    property Token: String read FToken write FToken;
  end;

implementation

end.
