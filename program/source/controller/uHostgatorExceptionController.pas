unit uHostgatorExceptionController;

interface

uses
  uJsonDTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TNotices = class
  end;

  THostgatorLoginException = class(TJsonDTO)
  private
    [JSONName('notices'), JSONMarshalled(False)]
    FNoticesArray: TArray<TNotices>;
    [GenericListReflect]
    FNotices: TObjectList<TNotices>;
    [JSONName('redirect')]
    FRedirect: string;
    [JSONName('security_token')]
    FSecurityToken: string;
    [JSONName('status')]
    FStatus: Integer;
    function GetNotices: TObjectList<TNotices>;
  protected
    function GetAsJson: string; override;
  published
    property Notices: TObjectList<TNotices> read GetNotices;
    property Redirect: string read FRedirect write FRedirect;
    property SecurityToken: string read FSecurityToken write FSecurityToken;
    property Status: Integer read FStatus write FStatus;
  public
    destructor Destroy; override;
  end;

  TMetadata = class
  end;

  THostgatorExceptionController = class(TJsonDTO)
  private
    [JSONName('errors')]
    FErrorsArray: TArray<string>;
    [JSONMarshalled(False)]
    FErrors: TList<string>;
    FMetadata: TMetadata;
    FStatus: Integer;
    function GetErrors: TList<string>;
  protected
    function GetAsJson: string; override;
  published
    property Errors: TList<string> read GetErrors;
    property Metadata: TMetadata read FMetadata;
    property Status: Integer read FStatus write FStatus;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

{ THostgatorLoginException }

destructor THostgatorLoginException.Destroy;
begin
  GetNotices.Free;
  inherited;
end;

function THostgatorLoginException.GetNotices: TObjectList<TNotices>;
begin
  Result := ObjectList<TNotices>(FNotices, FNoticesArray);
end;

function THostgatorLoginException.GetAsJson: string;
begin
  RefreshArray<TNotices>(FNotices, FNoticesArray);
  Result := inherited;
end;

{ THostgatorExceptionController }

constructor THostgatorExceptionController.Create;
begin
  inherited;
  FMetadata := TMetadata.Create;
end;

destructor THostgatorExceptionController.Destroy;
begin
  FMetadata.Free;
  GetErrors.Free;
  inherited;
end;

function THostgatorExceptionController.GetErrors: TList<string>;
begin
  Result := List<string>(FErrors, FErrorsArray);
end;

function THostgatorExceptionController.GetAsJson: string;
begin
  RefreshArray<string>(FErrors, FErrorsArray);
  Result := inherited;
end;

end.
