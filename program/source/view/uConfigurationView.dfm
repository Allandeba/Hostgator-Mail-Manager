inherited ConfigurationView: TConfigurationView
  Caption = 'ConfigurationView'
  ClientHeight = 179
  ClientWidth = 299
  ExplicitWidth = 311
  ExplicitHeight = 217
  TextHeight = 15
  object ImageTokenInformation: TImage
    Left = 8
    Top = 153
    Width = 16
    Height = 16
    OnClick = ImageTokenInformationClick
  end
  object LabeledEditMainUsername: TLabeledEdit
    Left = 8
    Top = 72
    Width = 282
    Height = 23
    EditLabel.Width = 103
    EditLabel.Height = 15
    EditLabel.Caption = 'Main API username'
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
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    LabelCaption = 'Token'
    Text = ''
  end
  object ButtonSave: TButton
    Left = 215
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 3
    OnClick = ButtonSaveClick
  end
end
