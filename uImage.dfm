object fImage: TfImage
  Left = 2111
  Top = 181
  Caption = 'Image control unit'
  ClientHeight = 272
  ClientWidth = 452
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label9: TLabel
    Left = 222
    Top = 35
    Width = 77
    Height = 13
    Caption = 'Casub Max (uM)'
  end
  object Label10: TLabel
    Left = 223
    Top = 54
    Width = 74
    Height = 13
    Caption = 'Casub Min (uM)'
  end
  object Label8: TLabel
    Left = 202
    Top = 91
    Width = 73
    Height = 13
    Caption = 'Pixels per voxel'
  end
  object Label5: TLabel
    Left = 201
    Top = 111
    Width = 76
    Height = 13
    Caption = 'JSR_paint_pixel'
  end
  object Label7: TLabel
    Left = 222
    Top = 11
    Width = 69
    Height = 13
    Caption = 'JSR Max (mM)'
  end
  object Label13: TLabel
    Left = 48
    Top = 235
    Width = 48
    Height = 13
    Caption = 'Text size='
  end
  object Label14: TLabel
    Left = 18
    Top = 192
    Width = 83
    Height = 13
    Caption = 'TextOfsetVmInX='
  end
  object Label15: TLabel
    Left = 18
    Top = 214
    Width = 83
    Height = 13
    Caption = 'TextOfsetVmInY='
  end
  object CheckBox1: TCheckBox
    Left = 13
    Top = 25
    Width = 107
    Height = 17
    Caption = 'mark CRU centers'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object CheckBox2: TCheckBox
    Left = 13
    Top = 9
    Width = 97
    Height = 17
    Caption = 'Show Ca sub'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object Edit7: TEdit
    Left = 155
    Top = 32
    Width = 61
    Height = 21
    TabOrder = 2
    Text = '10'
  end
  object Edit8: TEdit
    Left = 155
    Top = 51
    Width = 61
    Height = 21
    TabOrder = 3
    Text = '0.15'
  end
  object Edit6: TEdit
    Left = 155
    Top = 88
    Width = 41
    Height = 21
    TabOrder = 4
    Text = '4'
  end
  object Button3: TButton
    Left = 156
    Top = 139
    Width = 39
    Height = 25
    Caption = 'Update'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Edit5: TEdit
    Left = 155
    Top = 107
    Width = 41
    Height = 21
    TabOrder = 6
    Text = '6'
  end
  object RadioGroup2: TRadioGroup
    Left = 8
    Top = 88
    Width = 128
    Height = 72
    Caption = 'Center jSR to release'
    ItemIndex = 1
    Items.Strings = (
      'None'
      '1pixel plus'
      '1pixel minus')
    TabOrder = 7
  end
  object CheckBox3: TCheckBox
    Left = 13
    Top = 41
    Width = 97
    Height = 17
    Caption = 'show time'
    Checked = True
    State = cbChecked
    TabOrder = 8
  end
  object Button7: TButton
    Left = 318
    Top = 86
    Width = 97
    Height = 25
    Caption = 'show color sch'
    TabOrder = 9
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 318
    Top = 8
    Width = 97
    Height = 25
    Caption = 'Show Image'
    TabOrder = 10
    OnClick = Button8Click
  end
  object Edit10: TEdit
    Left = 156
    Top = 8
    Width = 60
    Height = 21
    TabOrder = 11
    Text = '0.3'
  end
  object Button5: TButton
    Left = 318
    Top = 39
    Width = 97
    Height = 25
    Caption = 'Image Refresh'
    TabOrder = 12
    OnClick = Button5Click
  end
  object Edit14: TEdit
    Left = 107
    Top = 234
    Width = 59
    Height = 21
    TabOrder = 13
    Text = '10'
  end
  object Edit15: TEdit
    Left = 107
    Top = 189
    Width = 59
    Height = 21
    TabOrder = 14
    Text = '500'
  end
  object RadioGroup3: TRadioGroup
    Left = 172
    Top = 184
    Width = 77
    Height = 52
    Caption = 'text'
    ItemIndex = 1
    Items.Strings = (
      'two lines'
      'one line')
    TabOrder = 15
  end
  object Edit16: TEdit
    Left = 107
    Top = 211
    Width = 59
    Height = 21
    TabOrder = 16
    Text = '20'
  end
end
