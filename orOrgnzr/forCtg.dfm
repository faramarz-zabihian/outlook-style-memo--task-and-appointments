object frmCategory: TfrmCategory
  Left = 192
  Top = 114
  Width = 321
  Height = 354
  BiDiMode = bdRightToLeft
  Caption = 'ÿ»ﬁÂ »‰œÌ ﬂ«—Â«'
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ParentBiDiMode = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 144
    Top = 16
    Width = 159
    Height = 13
    AutoSize = False
    Caption = '«‰ Œ«»Â« «“ «Ì‰ œ” Â Â« Â” ‰œ'
  end
  object cmdCancel: TButton
    Left = 146
    Top = 288
    Width = 76
    Height = 21
    Caption = '«‰’—«›'
    TabOrder = 0
    OnClick = cmdCancelClick
  end
  object cmdOk: TButton
    Left = 227
    Top = 288
    Width = 76
    Height = 21
    Caption = ' «ÌÌœ'
    TabOrder = 1
    OnClick = cmdOkClick
  end
  object meCat: TMemo
    Left = 90
    Top = 40
    Width = 213
    Height = 51
    Lines.Strings = (
      '')
    TabOrder = 2
    OnEnter = meCatEnter
  end
  object cmdAdd: TButton
    Left = 10
    Top = 40
    Width = 74
    Height = 22
    Caption = '«÷«›Â ﬂ‰'
    Enabled = False
    TabOrder = 3
    OnClick = cmdAddClick
  end
  object lbCat: TCheckListBox
    Left = 10
    Top = 97
    Width = 293
    Height = 186
    OnClickCheck = lbCatClickCheck
    ItemHeight = 13
    Sorted = True
    TabOrder = 4
    OnEnter = lbCatEnter
  end
  object cmdMCategory: TButton
    Left = 10
    Top = 288
    Width = 127
    Height = 21
    Caption = '›Â—”  «’·Ì'
    TabOrder = 5
    OnClick = cmdMCategoryClick
  end
end
