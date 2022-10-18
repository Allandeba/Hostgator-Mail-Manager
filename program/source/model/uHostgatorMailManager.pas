unit uHostgatorMailManager;

interface

uses
  uJsonDTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  THostgatorUserData = class
  private
    [JSONName('diskquota')]
    FDiskquota: string;
    [JSONName('_diskused')]
    FDiskused: string;
    [JSONName('diskusedpercent')]
    FDiskusedpercent: Integer;
    [JSONName('diskusedpercent20')]
    FDiskusedpercent20: Integer;
    [JSONName('diskusedpercent_float')]
    FDiskusedpercentFloat: Double;
    [JSONName('domain')]
    FDomain: string;
    [JSONName('email')]
    FEmail: string;
    [JSONName('humandiskquota')]
    FHumandiskquota: string;
    [JSONName('humandiskused')]
    FHumandiskused: string;
    [JSONName('login')]
    FLogin: string;
    [JSONName('mtime')]
    FMtime: Integer;
    [JSONName('suspended_incoming')]
    FSuspendedIncoming: Integer;
    [JSONName('suspended_login')]
    FSuspendedLogin: Integer;
    [JSONName('txtdiskquota')]
    FTxtdiskquota: string;
    [JSONName('user')]
    FUser: string;
  published
    property Diskquota: string read FDiskquota write FDiskquota;
    property Diskused: string read FDiskused write FDiskused;
    property Diskusedpercent: Integer read FDiskusedpercent write FDiskusedpercent;
    property Diskusedpercent20: Integer read FDiskusedpercent20 write FDiskusedpercent20;
    property DiskusedpercentFloat: Double read FDiskusedpercentFloat write FDiskusedpercentFloat;
    property Domain: string read FDomain write FDomain;
    property Email: string read FEmail write FEmail;
    property Humandiskquota: string read FHumandiskquota write FHumandiskquota;
    property Humandiskused: string read FHumandiskused write FHumandiskused;
    property Login: string read FLogin write FLogin;
    property Mtime: Integer read FMtime write FMtime;
    property SuspendedIncoming: Integer read FSuspendedIncoming write FSuspendedIncoming;
    property SuspendedLogin: Integer read FSuspendedLogin write FSuspendedLogin;
    property Txtdiskquota: string read FTxtdiskquota write FTxtdiskquota;
    property User: string read FUser write FUser;
  end;

  THostgatorUserDataList = class(TObjectList<THostgatorUserData>);
  
  TMetadata = class
  private
    [JSONName('records_before_filter')]
    FRecordsBeforeFilter: Integer;
    [JSONName('transformed')]
    FTransformed: Integer;
  published
    property RecordsBeforeFilter: Integer read FRecordsBeforeFilter write FRecordsBeforeFilter;
    property Transformed: Integer read FTransformed write FTransformed;
  end;
  
  THostgatorMailManagerUsers = class(TJsonDTO)
  private
    [JSONName('data'), JSONMarshalled(False)]
    FDataArray: TArray<THostgatorUserData>;
    [GenericListReflect]
    FData: TObjectList<THostgatorUserData>;
    [JSONName('metadata')]
    FMetadata: TMetadata;
    [JSONName('status')]
    FStatus: Integer;
    function GetData: TObjectList<THostgatorUserData>;
  protected
    function GetAsJson: string; override;
  published
    property Data: TObjectList<THostgatorUserData> read GetData;
    property Metadata: TMetadata read FMetadata;
    property Status: Integer read FStatus write FStatus;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;
  
implementation

{ TRootDTO }

constructor THostgatorMailManagerUsers.Create;
begin
  inherited;
  FMetadata := TMetadata.Create;
end;

destructor THostgatorMailManagerUsers.Destroy;
begin
  FMetadata.Free;
  GetData.Free;
  inherited;
end;

function THostgatorMailManagerUsers.GetData: TObjectList<THostgatorUserData>;
begin
  Result := ObjectList<THostgatorUserData>(FData, FDataArray);
end;

function THostgatorMailManagerUsers.GetAsJson: string;
begin
  RefreshArray<THostgatorUserData>(FData, FDataArray);
  Result := inherited;
end;

end.
