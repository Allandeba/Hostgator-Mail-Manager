inherited SystemLoginBaseView: TSystemLoginBaseView
  Caption = 'SystemLoginBaseView'
  ClientHeight = 169
  ClientWidth = 365
  OnKeyPress = FormKeyPress
  ExplicitWidth = 377
  ExplicitHeight = 207
  TextHeight = 15
  object ButtonLogin: TButton
    Left = 230
    Top = 121
    Width = 75
    Height = 25
    Caption = 'Login'
    TabOrder = 0
    OnClick = ButtonLoginClick
  end
  object ADComboBoxCompany: TADComboBox
    Left = 72
    Top = 24
    Width = 233
    Height = 45
    LabelCaption = 'Username'
  end
  object ADPasswordButtonedEdit: TADPasswordButtonedEdit
    Left = 72
    Top = 75
    Width = 233
    Height = 40
    LabelCaption = 'Password'
  end
end
