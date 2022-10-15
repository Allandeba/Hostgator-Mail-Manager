unit uMessages;

interface

uses
  uFrameworkMessages;

const
  INVALID_OPERATION = 'Invalid operation!';
  MISSING_INFORMATION = 'Missing data to continue!';

  MSG_0001 = 'Values must be filled to continue' + MSG_CRLF + 'Fill in the values before send the informations.';
  MSG_0002 = 'Error processing informations!' + MSG_CRLF + '%s';
  MSG_0003 = 'Successfully processed!';
  MSG_0004 = INVALID_OPERATION + MSG_CRLF + 'Password is invalid to this username.';
  MSG_0007 = INVALID_OPERATION + MSG_CRLF + 'You must have a valid user to delete.';
  MSG_0006 = 'Administrator required!' + MSG_CRLF + 'You must use the administrator password to modify this user.';
  MSG_0005 = MISSING_INFORMATION + MSG_CRLF + 'There are not mails to be loaded.';
  MSG_0009 = MISSING_INFORMATION + MSG_CRLF + 'You have to configure the system before start.';
  MSG_0010 = MISSING_INFORMATION + MSG_CRLF + 'Required information.';
  MSG_0012 = MISSING_INFORMATION + MSG_CRLF + 'archive not exist.';
  MSG_0013 = 'System update required' + MSG_CRLF + 'You must update the system to continue.';
  MSG_0014 = 'Overwriting information' + MSG_CRLF + 'It will erase the current token information.';

implementation

end.
