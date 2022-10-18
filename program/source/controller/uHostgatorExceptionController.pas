unit uHostgatorExceptionController;

interface

uses
  uJsonDTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
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
