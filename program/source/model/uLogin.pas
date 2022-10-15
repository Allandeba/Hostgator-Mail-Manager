unit uLogin;

interface

type
  TLogin = class
  private
    FEmailAddress: String;
    FDomain: String;
    FPassword: String;
  public
    property EmailAddress: String read FEmailAddress write FEmailAddress;
    property Domain: String read FDomain write FDomain;
    property Password: String read FPassword write FPassword;
  end;

implementation

end.
