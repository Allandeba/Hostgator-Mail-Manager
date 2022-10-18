unit uEnums;

interface

type
  TOperation = (oNone, oAddNew, oChangePassword, oDeleteEmail);
const
  TOperationValues: array [TOperation] of String = ('None', 'Add new', 'Change password', 'Delete email');

implementation

end.
