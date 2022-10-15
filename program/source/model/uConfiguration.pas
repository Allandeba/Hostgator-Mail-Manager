unit uConfiguration;

interface

uses
  uSessionInfo;

type
  TSessionManagerConfiguration = class(TSessionInfo);

  TConfiguration = class(TSessionManagerConfiguration)
  private
    FToken: String;
  public
    property Token: String read FToken write FToken;
  end;

implementation

end.
