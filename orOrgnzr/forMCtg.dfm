object frmMCategrory: TfrmMCategrory
  Left = 142
  Top = 82
  Width = 270
  Height = 333
  BiDiMode = bdRightToLeft
  Caption = 'ÿ»ﬁÂ »‰œÌ «’·Ì'
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
    Left = 205
    Top = 1
    Width = 48
    Height = 13
    Caption = 'ÿ»ﬁÂ ÃœÌœ'
  end
  object lbMCat: TListBox
    Left = 92
    Top = 52
    Width = 159
    Height = 212
    ItemHeight = 13
    MultiSelect = True
    Sorted = True
    TabOrder = 0
    OnEnter = lbMCatEnter
    OnExit = lbMCatExit
  end
  object txtNew: TEdit
    Left = 92
    Top = 20
    Width = 159
    Height = 21
    TabOrder = 1
    OnEnter = txtNewEnter
  end
  object cmdAdd: TButton
    Left = 12
    Top = 20
    Width = 74
    Height = 22
    Caption = '«÷«›Â'
    Enabled = False
    TabOrder = 2
    OnClick = cmdAddClick
  end
  object cmdDelete: TButton
    Left = 12
    Top = 52
    Width = 74
    Height = 22
    Caption = 'Õ–›'
    Enabled = False
    TabOrder = 3
    OnClick = cmdDeleteClick
  end
  object cmdRest: TButton
    Left = 12
    Top = 84
    Width = 74
    Height = 22
    Caption = '„ﬁ«œÌ— «Ê·ÌÂ'
    TabOrder = 4
    OnClick = cmdRestClick
  end
  object cmdOk: TButton
    Left = 137
    Top = 274
    Width = 78
    Height = 21
    Caption = ' «ÌÌœ'
    TabOrder = 5
    OnClick = cmdOkClick
  end
  object cmdCancel: TButton
    Left = 49
    Top = 274
    Width = 78
    Height = 21
    Caption = '«‰’—«›'
    TabOrder = 6
    OnClick = cmdCancelClick
  end
end
