inherited SystemLoginView: TSystemLoginView
  ClientWidth = 250
  ExplicitWidth = 256
  PixelsPerInch = 96
  TextHeight = 15
  object ImageConfig: TImage [0]
    Left = 8
    Top = 108
    Width = 16
    Height = 16
    OnClick = ImageConfigClick
  end
  inherited ButtonLogin: TButton
    OnClick = ButtonLoginClick
  end
end
