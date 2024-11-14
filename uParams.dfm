object fParams: TfParams
  Left = 0
  Top = 0
  Caption = 'Parameter set module'
  ClientHeight = 255
  ClientWidth = 897
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
    Left = 516
    Top = 38
    Width = 96
    Height = 13
    Caption = 'CRU_Casens, mM ='
  end
  object Label2: TLabel
    Left = 524
    Top = 62
    Width = 88
    Height = 13
    Caption = 'CRU_ProbConst ='
  end
  object Label3: TLabel
    Left = 499
    Top = 13
    Width = 113
    Height = 13
    Caption = 'CRU_ProbPower, mM ='
  end
  object Label24: TLabel
    Left = 20
    Top = 110
    Width = 49
    Height = 13
    Caption = 'Onset, ms'
  end
  object Label25: TLabel
    Left = 20
    Top = 134
    Width = 53
    Height = 13
    Caption = '% to apply'
  end
  object Label5: TLabel
    Left = 19
    Top = 65
    Width = 59
    Height = 13
    Caption = 'Frac Cav1.3'
  end
  object Label6: TLabel
    Left = 756
    Top = 8
    Width = 102
    Height = 13
    Caption = 'RyR sizes distributoin'
  end
  object Label7: TLabel
    Left = 240
    Top = 11
    Width = 124
    Height = 13
    Caption = 'NTicks_Diffu2D_Ring_FSR'
  end
  object Label8: TLabel
    Left = 240
    Top = 38
    Width = 124
    Height = 13
    Caption = 'NTicks_Diffu_FSR_to_JSR'
  end
  object Label9: TLabel
    Left = 208
    Top = 65
    Width = 156
    Height = 13
    Caption = 'NTicks_Diffu_Ring_to_Core_FSR'
  end
  object Label10: TLabel
    Left = 204
    Top = 92
    Width = 160
    Height = 13
    Caption = '  NTicks_Diffu_Ring_to_Core_Cyt'
  end
  object Label11: TLabel
    Left = 289
    Top = 119
    Width = 75
    Height = 13
    Caption = '  NTicks_SERCA'
  end
  object Label12: TLabel
    Left = 266
    Top = 146
    Width = 98
    Height = 13
    Caption = '  NTicks_test_trends'
  end
  object Label13: TLabel
    Left = 518
    Top = 92
    Width = 94
    Height = 13
    Caption = 'ScalingProbConst ='
  end
  object Label33: TLabel
    Left = 479
    Top = 146
    Width = 133
    Height = 13
    Caption = 'Ispark_Termination_scale ='
  end
  object Label14: TLabel
    Left = 486
    Top = 118
    Width = 124
    Height = 13
    Caption = 'Ispark_activation_tau_ms'
  end
  object Label15: TLabel
    Left = 288
    Top = 173
    Width = 75
    Height = 13
    Caption = 'Sr_Ca_t=0_mM'
  end
  object Label17: TLabel
    Left = 19
    Top = 12
    Width = 54
    Height = 13
    Caption = 'Pup mM/ms'
  end
  object Label18: TLabel
    Left = 18
    Top = 38
    Width = 55
    Height = 13
    Caption = 'gCaL nS/pF'
  end
  object Edit12: TEdit
    Left = 89
    Top = 8
    Width = 71
    Height = 21
    TabOrder = 0
    Text = '0.012'
  end
  object Edit13: TEdit
    Left = 89
    Top = 35
    Width = 71
    Height = 21
    TabOrder = 1
    Text = '0.464'
  end
  object Edit1: TEdit
    Left = 618
    Top = 35
    Width = 105
    Height = 21
    TabOrder = 2
    Text = '0.00015'
  end
  object Edit2: TEdit
    Left = 618
    Top = 62
    Width = 105
    Height = 21
    TabOrder = 3
    Text = '0.00027'
  end
  object Edit3: TEdit
    Left = 618
    Top = 8
    Width = 105
    Height = 21
    TabOrder = 4
    Text = '3'
  end
  object CheckBox3: TCheckBox
    Left = 19
    Top = 84
    Width = 152
    Height = 17
    Caption = 'beta adrenergic stimulation'
    TabOrder = 5
  end
  object Edit22: TEdit
    Left = 81
    Top = 107
    Width = 91
    Height = 21
    TabOrder = 6
    Text = '0'
  end
  object Edit23: TEdit
    Left = 81
    Top = 134
    Width = 91
    Height = 21
    TabOrder = 7
    Text = '100'
  end
  object Edit4: TEdit
    Left = 89
    Top = 62
    Width = 71
    Height = 21
    TabOrder = 8
    Text = '0.5'
  end
  object Memo1: TMemo
    Left = 744
    Top = 27
    Width = 127
    Height = 211
    Lines.Strings = (
      '0'#9'624'
      '16'#9'411'
      '32'#9'366'
      '48'#9'232'
      '64'#9'182'
      '80'#9'116'
      '96'#9'80'
      '112'#9'32'
      '128'#9'24'
      '144'#9'7'
      '160'#9'12'
      '176'#9'2'
      '192'#9'3')
    ScrollBars = ssVertical
    TabOrder = 9
  end
  object Edit5: TEdit
    Left = 372
    Top = 8
    Width = 53
    Height = 21
    TabOrder = 10
    Text = '5'
  end
  object Edit6: TEdit
    Left = 372
    Top = 35
    Width = 53
    Height = 21
    TabOrder = 11
    Text = '1'
  end
  object Edit7: TEdit
    Left = 372
    Top = 62
    Width = 53
    Height = 21
    TabOrder = 12
    Text = '10'
  end
  object Edit8: TEdit
    Left = 372
    Top = 89
    Width = 53
    Height = 21
    TabOrder = 13
    Text = '10'
  end
  object Edit9: TEdit
    Left = 372
    Top = 116
    Width = 53
    Height = 21
    TabOrder = 14
    Text = '5'
  end
  object Edit10: TEdit
    Left = 372
    Top = 143
    Width = 53
    Height = 21
    TabOrder = 15
    Text = '10'
  end
  object Edit11: TEdit
    Left = 618
    Top = 89
    Width = 105
    Height = 21
    TabOrder = 16
    Text = '1'
  end
  object CheckBox11: TCheckBox
    Left = 372
    Top = 197
    Width = 113
    Height = 17
    Caption = 'Do_Buffer_CQ_jSR'
    Checked = True
    State = cbChecked
    TabOrder = 17
  end
  object Edit25: TEdit
    Left = 618
    Top = 143
    Width = 105
    Height = 21
    TabOrder = 18
    Text = '1'
  end
  object Edit14: TEdit
    Left = 618
    Top = 116
    Width = 105
    Height = 21
    TabOrder = 19
    Text = '10'
  end
  object Edit15: TEdit
    Left = 372
    Top = 170
    Width = 103
    Height = 21
    TabOrder = 20
    Text = '1'
  end
  object CheckBox7: TCheckBox
    Left = 372
    Top = 220
    Width = 156
    Height = 18
    Caption = 'INI state: Steady-state fCQ'
    Checked = True
    State = cbChecked
    TabOrder = 21
  end
end
