unit uSystemStartup;

interface

uses
  Vcl.Controls;

type
  TSystemStartup = class
  private
    class procedure CheckVersion;
  {$HINTS OFF}
    class function ShowSystemLogin: TModalResult;
  {$HINTS ON}
    class procedure ShowGerenciadorEmail;
  public
    class procedure InitializeSystem;
  end;

implementation

uses
  Vcl.Forms, uHostgatorMailManagerView, uSystemLoginView, uVersionUpdateController, uFrameworkMessage, uMessages;

{ TSystemStartup }

class procedure TSystemStartup.CheckVersion;
var
  AVersionControlController: TVersionUpdateController;
begin
  AVersionControlController := TVersionUpdateController.Create;
  try
    if not AVersionControlController.HasUpdatedVersion then
    begin
      TMessageView.New(MSG_0013).Show;
      AVersionControlController.UpdateVersion;
    end;
  finally
    AVersionControlController.Free;
  end;
end;

class procedure TSystemStartup.InitializeSystem;
begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  CheckVersion;

  if ShowSystemLogin = mrOk then
    ShowGerenciadorEmail;
end;

class function TSystemStartup.ShowSystemLogin: TModalResult;
var
  ASystemLoginView: TSystemLoginView;
begin
  ASystemLoginView := TSystemLoginView.Create(nil);
  try
    Result := ASystemLoginView.ShowModal;
  finally
    ASystemLoginView.Free;
  end;
end;

class procedure TSystemStartup.ShowGerenciadorEmail;
var
  AHostgatorMailManagerView: THostgatorMailManagerView;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(THostgatorMailManagerView, AHostgatorMailManagerView);
  Application.Run;
end;

end.
