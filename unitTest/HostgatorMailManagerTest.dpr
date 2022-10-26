program HostgatorMailManagerTest;
{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$ENDIF }
  DUnitX.TestFramework,
  uCopyRequiredFilesToExeFilePath in 'uCopyRequiredFilesToExeFilePath.pas',
  uHostgatorExceptionController in '..\program\source\controller\uHostgatorExceptionController.pas',
  uHostgatorMailManagerController in '..\program\source\controller\uHostgatorMailManagerController.pas',
  uLoginController in '..\program\source\controller\uLoginController.pas',
  uVersionUpdateController in '..\program\source\controller\uVersionUpdateController.pas',
  uConsts in '..\program\source\model\uConsts.pas',
  uSystemInfo in '..\program\source\model\uSystemInfo.pas',
  uLogin in '..\program\source\model\uLogin.pas',
  uJsonDTO in '..\program\source\model\uJsonDTO.pas',
  uHostgatorMailManager in '..\program\source\model\uHostgatorMailManager.pas',
  uTokenManager in '..\program\source\model\uTokenManager.pas',
  uGithubReleases in '..\program\source\model\uGithubReleases.pas',
  uMessages in '..\program\source\model\uMessages.pas',
  uUnitTestUtils in 'uUnitTestUtils.pas',
  uVersionControllerTest in 'uVersionControllerTest.pas',
  uLoginControllerTest in 'uLoginControllerTest.pas',
  uHostgatorMailManagerControllerTest in 'uHostgatorMailManagerControllerTest.pas';

{$IFNDEF TESTINSIGHT}
var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger : ITestLogger;
{$ENDIF}
begin
  TCopyRequiredFilesToExeFilePath.Execute;
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //When true, Assertions must be made during tests;
    runner.FailsOnNoAsserts := False;
    //tell the runner how we will log things
    //Log to the console window if desired
    if TDUnitX.Options.ConsoleMode <> TDunitXConsoleMode.Off then
    begin
      logger := TDUnitXConsoleLogger.Create(TDUnitX.Options.ConsoleMode = TDunitXConsoleMode.Quiet);
      runner.AddLogger(logger);
    end;
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;
    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDIF}
end.
