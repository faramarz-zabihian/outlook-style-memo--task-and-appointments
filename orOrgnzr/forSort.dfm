object frmSortRows: TfrmSortRows
  Left = 341
  Top = 73
  Width = 396
  Height = 308
  BiDiMode = bdRightToLeft
  Caption = '„— » ”«“Ì'
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ParentBiDiMode = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 96
    Top = 16
    Width = 284
    Height = 52
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object cboSort1: TComboBox
      Left = 96
      Top = 16
      Width = 174
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = '«Ê·Ì‰'
      OnClick = cboSort1Click
    end
    object radUp1: TRadioButton
      Left = 25
      Top = 10
      Width = 57
      Height = 17
      Caption = '›“«Ì‰œÂ'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object radDown1: TRadioButton
      Left = 17
      Top = 28
      Width = 65
      Height = 17
      Caption = 'ﬂ«Â‰œÂ'
      TabOrder = 2
    end
  end
  object cmdOk: TButton
    Left = 8
    Top = 16
    Width = 76
    Height = 24
    Caption = ' «ÌÌœ'
    TabOrder = 1
    OnClick = cmdOkClick
  end
  object cmdCancel: TButton
    Left = 8
    Top = 48
    Width = 76
    Height = 24
    Caption = '«‰’—«›'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
  object cmdClear: TButton
    Left = 8
    Top = 80
    Width = 76
    Height = 24
    Caption = 'Õ–› Â„Â'
    TabOrder = 3
    OnClick = cmdClearClick
  end
  object Panel2: TPanel
    Left = 96
    Top = 83
    Width = 284
    Height = 52
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object cboSort2: TComboBox
      Tag = 1
      Left = 96
      Top = 16
      Width = 174
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'œÊ„Ì‰'
      OnClick = cboSort1Click
    end
    object radUp2: TRadioButton
      Left = 25
      Top = 10
      Width = 57
      Height = 17
      Caption = '›“«Ì‰œÂ'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object radDown2: TRadioButton
      Left = 17
      Top = 28
      Width = 65
      Height = 17
      Caption = 'ﬂ«Â‰œÂ'
      TabOrder = 2
    end
  end
  object Panel3: TPanel
    Left = 96
    Top = 149
    Width = 284
    Height = 52
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 5
    object cboSort3: TComboBox
      Tag = 2
      Left = 96
      Top = 16
      Width = 174
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = '”Ê„Ì‰'
      OnClick = cboSort1Click
    end
    object radUp3: TRadioButton
      Left = 25
      Top = 10
      Width = 57
      Height = 17
      Caption = '›“«Ì‰œÂ'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object radDown3: TRadioButton
      Left = 17
      Top = 28
      Width = 65
      Height = 17
      Caption = 'ﬂ«Â‰œÂ'
      TabOrder = 2
    end
  end
  object Panel4: TPanel
    Left = 96
    Top = 216
    Width = 284
    Height = 52
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 6
    object cboSort4: TComboBox
      Tag = 3
      Left = 96
      Top = 16
      Width = 174
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'ÃÂ«—„Ì‰'
      OnClick = cboSort1Click
    end
    object radUp4: TRadioButton
      Left = 25
      Top = 10
      Width = 57
      Height = 17
      Caption = '›“«Ì‰œÂ'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object radDown4: TRadioButton
      Left = 17
      Top = 28
      Width = 65
      Height = 17
      Caption = 'ﬂ«Â‰œÂ'
      TabOrder = 2
    end
  end
end
