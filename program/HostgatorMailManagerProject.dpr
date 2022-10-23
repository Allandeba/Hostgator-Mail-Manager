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
  uHostgatorMailManagerView in 'source\view\uHostgatorMailManagerView.pas' {HostgatorMailManagerView},
  uConfigurationView in 'source\view\uConfigurationView.pas' {ConfigurationView},
  uBaseView in 'source\view\uBaseView.pas' {BaseView},
  uConfigurationController in 'source\controller\uConfigurationController.pas',
  uConfiguration in 'source\model\uConfiguration.pas',
  uTokenManager in 'source\model\uTokenManager.pas',
  uLoginController in 'source\controller\uLoginController.pas',
  uEnums in 'source\model\uEnums.pas',
  uHostgatorMailManagerController in 'source\controller\uHostgatorMailManagerController.pas',
  uHostgatorMailManager in 'source\model\uHostgatorMailManager.pas',
  uJsonDTO in 'source\model\uJsonDTO.pas',
  uHostgatorExceptionController in 'source\controller\uHostgatorExceptionController.pas',
  uLogin in 'source\model\uLogin.pas',
  uGithubReleases in 'source\model\uGithubReleases.pas';

{$R *.res}

begin
  TSystemStartup.InitializeSystem;
end.
