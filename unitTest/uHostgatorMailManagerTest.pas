unit uHostgatorMailManagerTest;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  THostgatorMailManagerTest = class
  public
    [Test]
    procedure Test1;
    [Test]
    [TestCase('TestA','1,2')]
    [TestCase('TestB','3,4')]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

procedure THostgatorMailManagerTest.Test1;
begin

end;

procedure THostgatorMailManagerTest.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin

end;

initialization
  TDUnitX.RegisterTestFixture(THostgatorMailManagerTest);

end.
