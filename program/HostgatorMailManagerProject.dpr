program HostgatorMailManagerProject;

uses
  Vcl.Forms,
  uSystemStartup in 'source\model\uSystemStartup.pas',
  uMessages in 'source\model\uMessages.pas',
  uVersionUpdateController in 'source\controller\uVersionUpdateController.pas',
  uConsts in 'source\model\uConsts.pas',
  uSessionManager in 'source\model\uSessionManager.pas',
  uSystemInfo in 'source\model\uSystemInfo.pas',
  uSessionInfo in 'source\model\uSessionInfo.pas',
  uSystemLoginBaseView in 'source\view\uSystemLoginBaseView.pas' {SystemLoginBaseView},
  uSystemLoginView in 'source\view\uSystemLoginView.pas' {SystemLoginView},
  uHostgatorMailManagerView in 'source\view\uHostgatorMailManagerView.pas' {HostgatorMailManagerView};

{$R *.res}

begin
  TSystemStartup.InitializeSystem;
end.
