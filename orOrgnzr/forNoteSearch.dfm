object frmNoteSearch: TfrmNoteSearch
  Left = 230
  Top = 148
  BiDiMode = bdRightToLeft
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Ã” ÃÊÌ Ì«œœ«‘ Â«'
  ClientHeight = 79
  ClientWidth = 291
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  ParentBiDiMode = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 249
    Top = 16
    Width = 34
    Height = 13
    Caption = '»Â œ‰»«·'
  end
  object btnCancel: TBitBtn
    Left = 24
    Top = 48
    Width = 84
    Height = 25
    Caption = '«‰’—«›'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 225
    Height = 21
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    TabOrder = 0
    OnChange = Edit1Change
  end
  object btnNext: TBitBtn
    Left = 144
    Top = 48
    Width = 84
    Height = 25
    Caption = 'Ã” ÃÊ'
    Default = True
    Enabled = False
    TabOrder = 1
    OnClick = btnNextClick
  end
end
