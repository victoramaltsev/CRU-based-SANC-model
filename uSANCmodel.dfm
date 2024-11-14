object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 744
  ClientWidth = 862
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 82
    Top = 316
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 0
    Top = 393
    Width = 98
    Height = 13
    Caption = 'Output sampling, ms'
  end
  object Label3: TLabel
    Left = 8
    Top = 340
    Width = 79
    Height = 13
    Caption = 'Sim duration, ms'
  end
  object Label4: TLabel
    Left = 11
    Top = 81
    Width = 13
    Height = 13
    Caption = 'Dir'
  end
  object Label5: TLabel
    Left = 8
    Top = 102
    Width = 16
    Height = 13
    Caption = 'File'
  end
  object Label7: TLabel
    Left = 5
    Top = 128
    Width = 87
    Height = 13
    Caption = 'Loaded model file:'
  end
  object Label8: TLabel
    Left = 7
    Top = 141
    Width = 25
    Height = 13
    Caption = 'None'
  end
  object Label9: TLabel
    Left = 653
    Top = 315
    Width = 56
    Height = 13
    Caption = 'Bin, mkm = '
  end
  object Label10: TLabel
    Left = 497
    Top = 289
    Width = 40
    Height = 13
    Caption = 'Mean = '
  end
  object Label11: TLabel
    Left = 665
    Top = 290
    Width = 24
    Height = 13
    Caption = 'SD= '
  end
  object Label24: TLabel
    Left = 5
    Top = 671
    Width = 83
    Height = 13
    Caption = 'MaxNRyRsInCRU'
  end
  object Label25: TLabel
    Left = 8
    Top = 623
    Width = 104
    Height = 13
    Caption = 'TotalNCRUs real= ???'
  end
  object Label6: TLabel
    Left = 3
    Top = 581
    Width = 95
    Height = 13
    Caption = 'TotalNRyRs wanted'
  end
  object Label26: TLabel
    Left = 2
    Top = 697
    Width = 79
    Height = 13
    Caption = 'MinNRyRsInCRU'
  end
  object Label27: TLabel
    Left = 26
    Top = 366
    Width = 60
    Height = 13
    Caption = 'TimeTick, ms'
  end
  object Label31: TLabel
    Left = 7
    Top = 604
    Width = 106
    Height = 13
    Caption = 'TotalNRyRs real = ???'
  end
  object Label46: TLabel
    Left = 497
    Top = 311
    Width = 37
    Height = 13
    Caption = 'MaxY ='
  end
  object Label49: TLabel
    Left = 4
    Top = 562
    Width = 70
    Height = 13
    Caption = '16 RyRs/voxel'
  end
  object Label50: TLabel
    Left = 26
    Top = 316
    Width = 42
    Height = 13
    Caption = 'Time, ms'
  end
  object Label14: TLabel
    Left = 8
    Top = 642
    Width = 64
    Height = 13
    Caption = 'Success= ???'
  end
  object Button1: TButton
    Left = 106
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Run'
    Enabled = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 185
    Top = 8
    Width = 299
    Height = 724
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 102
    Top = 390
    Width = 73
    Height = 21
    TabOrder = 2
    Text = '0.75'
  end
  object Edit2: TEdit
    Left = 103
    Top = 338
    Width = 72
    Height = 21
    TabOrder = 3
    Text = '16000'
  end
  object Button6: TButton
    Left = 8
    Top = 8
    Width = 83
    Height = 25
    Caption = 'Model setup'
    TabOrder = 4
    OnClick = Button6Click
  end
  object Edit4: TEdit
    Left = 30
    Top = 79
    Width = 149
    Height = 21
    TabOrder = 5
    Text = 'C:\Users\Public\'
  end
  object Button7: TButton
    Left = 8
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Save model'
    TabOrder = 6
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 89
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Load model'
    TabOrder = 7
    OnClick = Button8Click
  end
  object Edit6: TEdit
    Left = 29
    Top = 101
    Width = 150
    Height = 21
    TabOrder = 8
    Text = 'model1'
  end
  object Button9: TButton
    Left = 577
    Top = 357
    Width = 151
    Height = 25
    Caption = 'Calculate NND histogram'
    Enabled = False
    TabOrder = 9
    OnClick = Button9Click
  end
  object Chart1: TChart
    Left = 495
    Top = 8
    Width = 331
    Height = 250
    Legend.Visible = False
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      'CRU statistics')
    Title.Visible = False
    View3D = False
    TabOrder = 10
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series1: TBarSeries
      Marks.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object Edit7: TEdit
    Left = 715
    Top = 313
    Width = 75
    Height = 21
    TabOrder = 11
    Text = '0.1'
  end
  object Edit8: TEdit
    Left = 543
    Top = 286
    Width = 91
    Height = 21
    TabOrder = 12
    Text = 'Edit8'
  end
  object Edit9: TEdit
    Left = 700
    Top = 286
    Width = 91
    Height = 21
    TabOrder = 13
    Text = 'Edit9'
  end
  object CheckBox2: TCheckBox
    Left = 26
    Top = 417
    Width = 97
    Height = 17
    Caption = 'Monitor Ca'
    TabOrder = 14
  end
  object Button10: TButton
    Left = 104
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Exit Program'
    TabOrder = 15
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 6
    Top = 39
    Width = 92
    Height = 25
    Caption = 'Stop simulations'
    TabOrder = 16
    OnClick = Button11Click
  end
  object Edit12: TEdit
    Left = 94
    Top = 667
    Width = 70
    Height = 21
    TabOrder = 17
    Text = '48'
  end
  object Edit5: TEdit
    Left = 102
    Top = 579
    Width = 73
    Height = 21
    TabOrder = 18
    Text = '83009'
  end
  object RadioGroup1: TRadioGroup
    Left = 9
    Top = 440
    Width = 170
    Height = 73
    Caption = 'RyR size distribution'
    Color = clInfoBk
    ItemIndex = 1
    Items.Strings = (
      'Equal#CRU of each size'
      'Read from memo')
    ParentBackground = False
    ParentColor = False
    TabOrder = 19
  end
  object Edit24: TEdit
    Left = 94
    Top = 694
    Width = 70
    Height = 21
    TabOrder = 20
    Text = '48'
  end
  object Button21: TButton
    Left = 574
    Top = 388
    Width = 154
    Height = 25
    Caption = 'Histo NCRU of each size'
    TabOrder = 21
    OnClick = Button21Click
  end
  object Button22: TButton
    Left = 577
    Top = 419
    Width = 156
    Height = 25
    Caption = 'Histo NRyRs in CRU each size'
    TabOrder = 22
    OnClick = Button22Click
  end
  object Edit22: TEdit
    Left = 103
    Top = 363
    Width = 72
    Height = 21
    TabOrder = 23
    Text = '0.0075'
  end
  object Edit34: TEdit
    Left = 543
    Top = 308
    Width = 91
    Height = 21
    TabOrder = 24
    Text = '350'
  end
  object CheckBox11: TCheckBox
    Left = 542
    Top = 330
    Width = 81
    Height = 17
    Caption = 'Y autoscale'
    Checked = True
    State = cbChecked
    TabOrder = 25
  end
  object GroupBox1: TGroupBox
    Left = 513
    Top = 458
    Width = 176
    Height = 252
    Caption = 'Repulsion'
    TabOrder = 26
    object Label33: TLabel
      Left = 22
      Top = 61
      Width = 89
      Height = 13
      Caption = 'Repultion strength'
    end
    object Label34: TLabel
      Left = 36
      Top = 218
      Width = 26
      Height = 13
      Caption = 'Tick#'
    end
    object Label35: TLabel
      Left = 76
      Top = 35
      Width = 26
      Height = 13
      Caption = 'steps'
    end
    object Label38: TLabel
      Left = 76
      Top = 87
      Width = 35
      Height = 13
      Caption = 'Friction'
    end
    object Label39: TLabel
      Left = 15
      Top = 120
      Width = 96
      Height = 13
      Caption = 'Integration in dx,dy'
    end
    object Label40: TLabel
      Left = 71
      Top = 147
      Width = 39
      Height = 13
      Caption = 'time tick'
    end
    object Edit13: TEdit
      Left = 117
      Top = 60
      Width = 49
      Height = 21
      TabOrder = 0
      Text = '0.08'
    end
    object Button23: TButton
      Left = 38
      Top = 187
      Width = 75
      Height = 25
      Caption = 'Do repulsion'
      TabOrder = 1
      OnClick = Button23Click
    end
    object Edit25: TEdit
      Left = 117
      Top = 33
      Width = 49
      Height = 21
      TabOrder = 2
      Text = '100'
    end
    object Edit28: TEdit
      Left = 117
      Top = 87
      Width = 49
      Height = 21
      TabOrder = 3
      Text = '30'
    end
    object Edit29: TEdit
      Left = 117
      Top = 114
      Width = 49
      Height = 21
      TabOrder = 4
      Text = '50'
    end
    object Edit30: TEdit
      Left = 116
      Top = 141
      Width = 49
      Height = 21
      TabOrder = 5
      Text = '1'
    end
    object Button31: TButton
      Left = 119
      Top = 187
      Width = 47
      Height = 25
      Caption = 'Stop'
      TabOrder = 6
      OnClick = Button31Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 198
    Width = 146
    Height = 86
    Caption = 'Forms'
    Color = clLime
    ParentBackground = False
    ParentColor = False
    TabOrder = 27
    object Button2: TButton
      Left = 6
      Top = 49
      Width = 47
      Height = 25
      Caption = 'Plots'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 6
      Top = 18
      Width = 45
      Height = 25
      Caption = 'Images'
      TabOrder = 1
      OnClick = Button3Click
    end
    object Button16: TButton
      Left = 57
      Top = 18
      Width = 62
      Height = 25
      Caption = 'Img Control'
      TabOrder = 2
      OnClick = Button16Click
    end
    object Button18: TButton
      Left = 57
      Top = 49
      Width = 66
      Height = 25
      Caption = 'Parameters'
      TabOrder = 3
      OnClick = Button18Click
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 293
    Top = 107
  end
end
