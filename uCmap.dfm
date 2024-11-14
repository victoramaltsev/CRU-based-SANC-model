object fCmap: TfCmap
  Left = 0
  Top = 0
  Caption = 'fCmap'
  ClientHeight = 662
  ClientWidth = 670
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 49
    Top = 21
    Width = 256
    Height = 38
  end
  object Image2: TImage
    Left = 49
    Top = 75
    Width = 256
    Height = 38
  end
  object Image4: TImage
    Left = 49
    Top = 200
    Width = 256
    Height = 38
  end
  object Image3: TImage
    Left = 49
    Top = 136
    Width = 256
    Height = 38
  end
  object Label1: TLabel
    Left = 49
    Top = 59
    Width = 74
    Height = 13
    Caption = 'Color Scheme 1'
  end
  object Label2: TLabel
    Left = 49
    Top = 117
    Width = 74
    Height = 13
    Caption = 'Color Scheme 2'
  end
  object Label3: TLabel
    Left = 49
    Top = 181
    Width = 74
    Height = 13
    Caption = 'Color Scheme 3'
  end
  object Label5: TLabel
    Left = 49
    Top = 2
    Width = 74
    Height = 13
    Caption = 'Color Scheme 0'
  end
  object Image5: TImage
    Left = 49
    Top = 264
    Width = 256
    Height = 38
  end
  object Label4: TLabel
    Left = 49
    Top = 245
    Width = 74
    Height = 13
    Caption = 'Color Scheme 4'
  end
  object Image6: TImage
    Left = 49
    Top = 392
    Width = 256
    Height = 38
  end
  object Label6: TLabel
    Left = 49
    Top = 373
    Width = 74
    Height = 13
    Caption = 'Color Scheme 5'
  end
  object Image7: TImage
    Left = 28
    Top = 548
    Width = 256
    Height = 38
  end
  object Label7: TLabel
    Left = 28
    Top = 534
    Width = 74
    Height = 13
    Caption = 'Color Scheme 6'
  end
  object ScrollBar1: TScrollBar
    Left = 28
    Top = 308
    Width = 295
    Height = 14
    Max = 255
    PageSize = 0
    Position = 105
    TabOrder = 0
    OnChange = ScrollBar1Change
  end
  object ScrollBar2: TScrollBar
    Left = 28
    Top = 327
    Width = 295
    Height = 14
    Max = 255
    PageSize = 0
    Position = 155
    TabOrder = 1
    OnChange = ScrollBar2Change
  end
  object ScrollBar3: TScrollBar
    Left = 28
    Top = 348
    Width = 295
    Height = 14
    Max = 255
    PageSize = 0
    Position = 208
    TabOrder = 2
    OnChange = ScrollBar3Change
  end
  object ScrollBar4: TScrollBar
    Left = 28
    Top = 436
    Width = 295
    Height = 14
    Max = 255
    PageSize = 0
    Position = 28
    TabOrder = 3
    OnChange = ScrollBar4Change
  end
  object ScrollBar5: TScrollBar
    Left = 28
    Top = 455
    Width = 295
    Height = 14
    Max = 255
    PageSize = 0
    Position = 92
    TabOrder = 4
    OnChange = ScrollBar5Change
  end
  object ScrollBar6: TScrollBar
    Left = 28
    Top = 476
    Width = 295
    Height = 14
    Max = 255
    PageSize = 0
    Position = 157
    TabOrder = 5
    OnChange = ScrollBar6Change
  end
  object ScrollBar7: TScrollBar
    Left = 28
    Top = 496
    Width = 295
    Height = 14
    Max = 255
    PageSize = 0
    Position = 221
    TabOrder = 6
    OnChange = ScrollBar7Change
  end
  object Button1: TButton
    Left = 326
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 7
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 328
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 8
    OnClick = Button2Click
  end
  object RadioGroup1: TRadioGroup
    Left = 456
    Top = 117
    Width = 153
    Height = 180
    Caption = 'Choice'
    ItemIndex = 0
    Items.Strings = (
      'Color Scheme0'
      'Color Scheme1'
      'Color Scheme2'
      'Color Scheme3'
      'Color Scheme4'
      'Color Scheme5'
      'Color Scheme6')
    TabOrder = 9
    OnClick = RadioGroup1Click
  end
end
