unit uConsts;

interface

uses
  uFrameworkConsts;

const
  // System information
  SYSTEM_NAME = 'Hostgator Mail Manager';
  SYSTEM_EXTENSION = '.exe';

  // Default archives
  CONFIG_FILE = 'config.ini';
  DOMAIN_FILE = 'company.ini';

  // Local version archive
  FILENAME_VERSION_API = 'version.json';
  VERSION_PATH = SOURCE_FOLDER + FILENAME_VERSION_API;
  SYSTEM_PARAM_DOMAIN = 'DOMAIN';
  SYSTEM_PARAM_MAIN_MAIL = 'MAIN_API_MAIL';

  // Used token to criptograph
  TOKEN_CRIPTOGRAFADOR = 'bb+1%$77OOBUJdU?L3TKRIBc$F)J1?tuvb&r8bt0';

  // Hostgator configuration
  USER_HOSTGATOR = 'empty';
  URL_HOSTGATOR = 'empty';
  URL_WEBMAIL = 'https://webmail.';

  // Hostgator API configurations
  HOSTGATOR_MAIL_ACCESS = '/login/?login_only=1';
  HOSTGATOR_MAIL_ADD = 'add_pop';
  HOSTGATOR_MAIL_UPDATE = 'passwd_pop';
  HOSTGATOR_MAIL_DELETE = 'delete_pop';
  HOSTGATOR_GET_ALL_MAILS = 'list_pops_with_disk';

  // Error result when it is all ok between data from hostgator.
  HOSTGATOR_RETURN_MAIL_MESSAGE_OK = 'This is a message.';

  IMG_BUTTON_PASSWORD_1 = IMG_FOLDER + 'closed_eye.png';
  IMG_BUTTON_PASSWORD_2 = IMG_FOLDER + 'opened_eye.png';

  // GitHub configuration
  GITHUB_OWNER_USERNAME = 'Allandeba';
  GITHUB_PROJECT_REPOSITORY_NAME = 'Hostgator-Mail-Manager';
  GITHUB_DEFAULT_API_REPOSITORY = 'https://api.github.com/repos/';

  GITHUB_PARAM_ACTUAL_RELEASE_VERSION = 'tag_name';
  GITHUB_PARAM_RELEASE_VERSION = 'assets';
  GITHUB_PARAM_URL_GET_RELEASES = GITHUB_DEFAULT_API_REPOSITORY + GITHUB_OWNER_USERNAME + '/' + GITHUB_PROJECT_REPOSITORY_NAME + '/releases';
  GITHUB_PARAM_DOWNLOAD_NEW_EXE_VERSION_URL = 'browser_download_url';
  GITHUB_PARAM_RELEASE_URL = 'url';

implementation

end.
