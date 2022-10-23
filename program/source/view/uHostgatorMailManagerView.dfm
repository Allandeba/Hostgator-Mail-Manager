object HostgatorMailManagerView: THostgatorMailManagerView
  Left = 0
  Top = 0
  Caption = 'Manager'
  ClientHeight = 75
  ClientWidth = 243
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 15
  object FlowPanelButtons: TFlowPanel
    AlignWithMargins = True
    Left = 3
    Top = 42
    Width = 237
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'FlowPanelButtons'
    FlowStyle = fsRightLeftBottomTop
    ShowCaption = False
    TabOrder = 1
    VerticalAlignment = taAlignBottom
    object ButtonSend: TButton
      AlignWithMargins = True
      Left = 159
      Top = 2
      Width = 75
      Height = 25
      Caption = 'Send'
      TabOrder = 0
      OnClick = ButtonSendClick
    end
  end
  object FlowPanelOperation: TFlowPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 237
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Caption = 'FlowPanelOperation'
    FlowStyle = fsRightLeftBottomTop
    ShowCaption = False
    TabOrder = 0
    VerticalAlignment = taAlignBottom
    object ADComboBoxOperation: TADComboBox
      AlignWithMargins = True
      Left = 5
      Top = -3
      Width = 229
      Height = 40
      LabelCaption = 'Operation'
      Text = ''
      ItemIndex = -1
      TabOrder = 0
      BevelOuter = bvNone
    end
  end
end
