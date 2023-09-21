object frmRemind: TfrmRemind
  Left = 192
  Top = 114
  Width = 363
  Height = 180
  BiDiMode = bdRightToLeft
  Caption = 'a'
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ParentBiDiMode = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblSubject: TLabel
    Left = 112
    Top = 8
    Width = 233
    Height = 97
    AutoSize = False
    Caption = '„ ‰ Ì«≈¬Ê—Ì'
    WordWrap = True
  end
  object Bevel1: TBevel
    Left = 8
    Top = 111
    Width = 337
    Height = 10
    Shape = bsBottomLine
  end
  object Label2: TLabel
    Left = 168
    Top = 128
    Width = 177
    Height = 17
    AutoSize = False
    Caption = '»—«Ì Ì«œ¬Ê—Ì „Ãœœ œﬂ„Â  ⁄ÊÌﬁ —« »“‰Ìœ'
  end
  object cmdDismiss: TBitBtn
    Left = 8
    Top = 8
    Width = 74
    Height = 21
    Caption = '’—›‰Ÿ—'
    TabOrder = 0
    OnClick = cmdDismissClick
  end
  object cmdPostpone: TBitBtn
    Left = 8
    Top = 39
    Width = 74
    Height = 21
    Caption = ' ⁄ÊÌﬁ'
    TabOrder = 1
    OnClick = cmdPostponeClick
  end
  object cmdOpen: TBitBtn
    Left = 8
    Top = 84
    Width = 74
    Height = 21
    Caption = '»«“ﬂ—œ‰'
    TabOrder = 2
    OnClick = cmdOpenClick
  end
  object cboTime: TComboBox
    Left = 8
    Top = 128
    Width = 153
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    OnClick = cboTimeClick
  end
end
