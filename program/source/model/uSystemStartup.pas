unit uSystemStartup;

interface

uses
  Vcl.Controls;

type
  TSystemStartup = class
  private
    class procedure CheckVersion;
    class procedure LoadSessionInformation;
  {$HINTS OFF}
    class function ShowSystemLogin: TModalResult;
  {$HINTS ON}
    class procedure ShowGerenciadorEmail;
  public
    class procedure InitializeSystem;
  end;

implementation

uses
  Vcl.Forms, uHostgatorMailManagerView, uSystemLoginView, uVersionUpdateController, uFrameworkMessage, uMessages, uConfigurationController;

{ TSystemStartup }

class procedure TSystemStartup.CheckVersion;
var
  AVersionControlController: TVersionUpdateController;
begin
  AVersionControlController := TVersionUpdateController.Create;
  try
    if AVersionControlController.HasUpdatedVersion then
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

  {$IFDEF RELEASE}
  CheckVersion;
  {$ENDIF}
  LoadSessionInformation;

  if ShowSystemLogin = mrOk then
    ShowGerenciadorEmail;
end;

class procedure TSystemStartup.LoadSessionInformation;
var
  AConfigurationController: TConfigurationController;
begin
  AConfigurationController := TConfigurationController.Create;
  try
    AConfigurationController.LoadSessionInformation;
  finally
    AConfigurationController.Free;
  end;
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
