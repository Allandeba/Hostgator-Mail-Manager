inherited SystemLoginBaseView: TSystemLoginBaseView
  BorderStyle = bsDialog
  Caption = 'SystemLoginBaseView'
  ClientHeight = 124
  ClientWidth = 246
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  ExplicitWidth = 262
  ExplicitHeight = 163
  TextHeight = 15
  object ButtonLogin: TButton
    Left = 166
    Top = 99
    Width = 75
    Height = 25
    Caption = 'Login'
    TabOrder = 2
    OnClick = ButtonLoginClick
  end
  object LabeledEditUsername: TLabeledEdit
    Left = 8
    Top = 22
    Width = 233
    Height = 23
    EditLabel.Width = 53
    EditLabel.Height = 15
    EditLabel.Caption = 'Username'
    TabOrder = 0
    Text = ''
  end
  object ADPasswordButtonedEdit: TADPasswordButtonedEdit
    Left = 8
    Top = 51
    Width = 233
    Height = 40
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    LabelCaption = 'Password'
    Text = ''
  end
end
