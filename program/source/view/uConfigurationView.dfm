inherited ConfigurationView: TConfigurationView
  Caption = 'Configuration'
  ClientHeight = 276
  ClientWidth = 296
  ExplicitWidth = 308
  ExplicitHeight = 314
  TextHeight = 15
  object ImageTokenInformation: TImage
    Left = 9
    Top = 254
    Width = 16
    Height = 16
    OnClick = ImageTokenInformationClick
  end
  object LabeledEditMainUsername: TLabeledEdit
    Left = 8
    Top = 72
    Width = 282
    Height = 23
    EditLabel.Width = 135
    EditLabel.Height = 15
    EditLabel.Caption = 'Main API email username'
    TabOrder = 1
    Text = ''
  end
  object LabeledEditDomain: TLabeledEdit
    Left = 8
    Top = 115
    Width = 282
    Height = 23
    EditLabel.Width = 42
    EditLabel.Height = 15
    EditLabel.Caption = 'Domain'
    TabOrder = 2
    Text = ''
  end
  object ADPasswordButtonedEditToken: TADPasswordButtonedEdit
    Left = 8
    Top = 8
    Width = 282
    Height = 40
    LabelCaption = 'Token'
    Text = ''
    TabOrder = 0
  end
  object ButtonSave: TButton
    Left = 216
    Top = 245
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 5
    OnClick = ButtonSaveClick
  end
  object LabeledEditHostgatorUsername: TLabeledEdit
    Left = 8
    Top = 160
    Width = 283
    Height = 23
    EditLabel.Width = 108
    EditLabel.Height = 15
    EditLabel.Caption = 'Hostgator username'
    TabOrder = 3
    Text = ''
  end
  object LabeledEditHostgatorHostIP: TLabeledEdit
    Left = 8
    Top = 208
    Width = 283
    Height = 23
    EditLabel.Width = 109
    EditLabel.Height = 15
    EditLabel.Caption = 'Hostgator hosting IP'
    TabOrder = 4
    Text = ''
  end
end
