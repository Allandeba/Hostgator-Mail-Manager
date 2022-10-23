inherited SystemLoginBaseView: TSystemLoginBaseView
  BorderStyle = bsDialog
  Caption = 'Login'
  ClientHeight = 130
  ClientWidth = 251
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  ExplicitWidth = 257
  ExplicitHeight = 159
  PixelsPerInch = 96
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
  end
  object ADPasswordButtonedEdit: TADPasswordButtonedEdit
    Left = 8
    Top = 51
    Width = 233
    Height = 40
    LabelCaption = 'Password'
    Text = ''
    TabOrder = 1
    BevelOuter = bvNone
  end
end
