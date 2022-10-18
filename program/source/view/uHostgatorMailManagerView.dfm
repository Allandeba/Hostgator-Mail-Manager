object HostgatorMailManagerView: THostgatorMailManagerView
  Left = 0
  Top = 0
  Caption = 'HostgatorMailManagerView'
  ClientHeight = 191
  ClientWidth = 258
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object ADComboBoxOperation: TADComboBox
    Left = 8
    Top = 8
    Width = 239
    Height = 45
    LabelCaption = 'Operation'
  end
  object ADComboBoxUsername: TADComboBox
    Left = 8
    Top = 59
    Width = 112
    Height = 45
    LabelCaption = 'Username'
  end
  object ButtonSend: TButton
    Left = 172
    Top = 156
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 2
    OnClick = ButtonSendClick
  end
  object LabeledEditDomain: TLabeledEdit
    Left = 126
    Top = 81
    Width = 121
    Height = 23
    EditLabel.Width = 42
    EditLabel.Height = 15
    EditLabel.Caption = 'Domain'
    TabOrder = 3
    Text = ''
  end
  object ADPasswordButtonedEditPassword: TADPasswordButtonedEdit
    Left = 8
    Top = 110
    Width = 239
    Height = 40
    BevelOuter = bvNone
    Caption = 'ADPasswordButtonedEditPassword'
    ShowCaption = False
    TabOrder = 4
    LabelCaption = 'Password'
    Text = ''
  end
end
