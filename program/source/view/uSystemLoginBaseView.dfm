inherited SystemLoginBaseView: TSystemLoginBaseView
  BorderStyle = bsNone
  Caption = 'SystemLoginBaseView'
  ClientHeight = 140
  ClientWidth = 286
  OnKeyPress = FormKeyPress
  ExplicitWidth = 286
  ExplicitHeight = 140
  TextHeight = 15
  object ButtonLogin: TButton
    Left = 183
    Top = 102
    Width = 75
    Height = 25
    Caption = 'Login'
    TabOrder = 2
    OnClick = ButtonLoginClick
  end
  object ADPasswordButtonedEdit: TADPasswordButtonedEdit
    Tag = 1
    Left = 25
    Top = 56
    Width = 233
    Height = 40
    LabelCaption = 'Password'
  end
  object LabeledEditUsername: TLabeledEdit
    Left = 25
    Top = 27
    Width = 233
    Height = 23
    EditLabel.Width = 53
    EditLabel.Height = 15
    EditLabel.Caption = 'Username'
    TabOrder = 0
    Text = ''
  end
end
