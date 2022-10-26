unit uCopyRequiredFilesToExeFilePath;

interface

type
  TCopyRequiredFilesToExeFilePath = class
  private
    class function GetDefaultRequiredFolderPath: String;
    class function GetFilePathWhereToCopy: String;
    class procedure CopyRequiredFiles;
    class procedure CheckIfRequiredFolderExists;
  public
    class procedure Execute;
  end;

const
  DEFAULT_FOLDER_FILE_NAME = 'File2ExeFolder/Source';

implementation

uses
  System.SysUtils, System.Classes, Vcl.Forms, System.IOUtils;

{ TCopyRequiredFilesToExeFilePath }

class procedure TCopyRequiredFilesToExeFilePath.CheckIfRequiredFolderExists;
begin
  TDirectory.Exists(GetFilePathWhereToCopy)
end;

class procedure TCopyRequiredFilesToExeFilePath.CopyRequiredFiles;
begin
  if not TDirectory.Exists(GetDefaultRequiredFolderPath) then
    raise Exception.Create(Format('Can not find required folder.%s%s', [sLineBreak, GetDefaultRequiredFolderPath]));
  TDirectory.Copy(GetDefaultRequiredFolderPath, GetFilePathWhereToCopy);
end;

class procedure TCopyRequiredFilesToExeFilePath.Execute;
begin
  CopyRequiredFiles;
  CheckIfRequiredFolderExists;
end;

class function TCopyRequiredFilesToExeFilePath.GetDefaultRequiredFolderPath: String;
begin
  Result := Format('%s..\..\%s', [ExtractFilePath(Application.ExeName), DEFAULT_FOLDER_FILE_NAME]);
end;

class function TCopyRequiredFilesToExeFilePath.GetFilePathWhereToCopy: String;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

end.
