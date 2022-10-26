unit uConsts;

interface

uses
  uFrameworkConsts;

const
  // System information
  SYSTEM_NAME = 'Hostgator Mail Manager';
  SYSTEM_THEME = 'Glow';
  SYSTEM_EXTENSION = '.exe';

  // Default archives
  CONFIG_FILE = 'config.ini';
  COMPANY_FILE = 'company.ini';

  // Local version archive
  FILENAME_VERSION_API = 'version.ini';
  VERSION_PATH = SOURCE_FOLDER + FILENAME_VERSION_API;
  VERSION_PARAM = 'VERSION';
  SYSTEM_PARAM_DOMAIN = 'DOMAIN';
  SYSTEM_PARAM_MAIN_EMAIL_USERNAME = 'MAIN_EMAIL_USERNAME';
  SYSTEM_PARAM_HOSTGATOR_USERNAME = 'HOSTGATOR_USERNAME';
  SYSTEM_PARAM_HOSTGATOR_HOST_IP = 'HOSTGATOR_HOST_IP';

  // Used token to criptograph
  TOKEN_CRIPTOGRAFADOR = 'bb+1%$77OOBUJdU?L3TKRIBc$F)J1?tuvb&r8bt0';

  // Hostgator configuration
  URL_WEBMAIL = 'https://webmail.';

  // Hostgator API configurations
  HOSTGATOR_MAIL_ACCESS = '/login/?login_only=1';
  HOSTGATOR_MAIL_ADD = 'add_pop';
  HOSTGATOR_MAIL_UPDATE = 'passwd_pop';
  HOSTGATOR_MAIL_DELETE = 'delete_pop';
  HOSTGATOR_GET_ALL_MAILS = 'list_pops_with_disk';

  // Error result when it is all ok between data from hostgator.
  HOSTGATOR_RETURN_MAIL_MESSAGE_OK = 'This is a message.';

  // Images
  IMG_BLACK_FOLDER = 'black_theme/';
  IMG_WHITE_FOLDER = 'white_theme/';
  IMG_BUTTON_PASSWORD_1 = 'closed_eye.png';
  IMG_BUTTON_PASSWORD_2 = 'opened_eye.png';
  IMG_RETRIEVE_TOKEN_INFORMATION = 'sync-configuration.png';
  IMG_SETTINGS = 'settings.png';

  // GitHub configuration
  GITHUB_DEFAULT_API_REPOSITORY = 'https://api.github.com/repos/';
  GITHUB_OWNER_USERNAME = 'Allandeba';
  GITHUB_PROJECT_REPOSITORY_NAME = 'Hostgator-Mail-Manager';
  GITHUB_PARAM_URL_GET_RELEASES = GITHUB_DEFAULT_API_REPOSITORY + GITHUB_OWNER_USERNAME + '/' + GITHUB_PROJECT_REPOSITORY_NAME + '/releases';

implementation

end.
