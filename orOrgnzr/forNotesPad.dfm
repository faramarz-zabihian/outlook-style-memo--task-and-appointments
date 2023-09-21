object frmNotesPad: TfrmNotesPad
  Left = 295
  Top = 102
  Width = 449
  Height = 418
  BorderIcons = [biSystemMenu]
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lv: TListView
    Left = 0
    Top = 49
    Width = 441
    Height = 314
    Align = alClient
    BiDiMode = bdRightToLeft
    Columns = <>
    DragMode = dmAutomatic
    Font.Charset = ARABIC_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    HideSelection = False
    MultiSelect = True
    OwnerDraw = True
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 0
    OnCompare = lvCompare
    OnDblClick = lvDblClick
    OnDragDrop = lvDragDrop
    OnDragOver = lvDragOver
    OnKeyUp = lvKeyUp
    OnMouseDown = lvMouseDown
    OnSelectItem = lvSelectItem
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 441
    Height = 49
    Align = alTop
    BiDiMode = bdRightToLeft
    ParentBiDiMode = False
    TabOrder = 1
    object Label1: TLabel
      Left = 301
      Top = 1
      Width = 139
      Height = 47
      Align = alRight
      Alignment = taCenter
      AutoSize = False
      BiDiMode = bdRightToLeft
      Caption = 'Ì«œœ«‘ '
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
      ParentBiDiMode = False
      ParentFont = False
      Layout = tlCenter
    end
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 33
      Height = 47
      Align = alLeft
      Picture.Data = {
        055449636F6E0000010001002020100000000000E80200001600000028000000
        2000000040000000010004000000000080020000000000000000000000000000
        0000000000000000000080000080000000808000800000008000800080800000
        C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
        FFFFFF0077777777777777777777777777777777777777777777777777777777
        777777777777777777000077777777777777777777777777707FFF0077777777
        777777777777777707BFBFFF0077777777777777777777707BFBFFBFFB007777
        7777777777777770BFBFBFFFFFFF00777777777777777707FBFBFBFBFBFFFB00
        777777777777770FBFBF37BFBFFFFFFB007777777777707BFBFB77777BFBFBFF
        FB007777777770BFBFB73787B7BFFFFFFFFB0077777707FBFBFBF37373FB7BFF
        BFFFFB0077770FBFB73FBFB73FB737BFFFFBFFF877707BFBF8737BFBFB78F78B
        FBFFFFF87770BFBFB7B787B7BFB7B7F737FFBF877707FBFBFB7B78737BFB7373
        F77FF877770FBFB7BFBF3737877FBFBF37BFB877707BFB787B7BFBFB73787BFF
        7FFF877770BFBF37B787BFBFBF38877FBFBF877707FBFBFB7B7378FBFBFB737B
        FFF8777707BFBFBFBFB737B7BFBFBF3FBFB87777788BFBFBFB778BF373FBFBFB
        FB87777777788FBFBFBFBF3FB787B7BFBF8777777777788BFBFBFBF37B887BFB
        F8777777777777788FBFBFBFBFB73FBFB877777777777777788BFBFBFBFBFBFB
        877777777777777777788FBFBFBFBFBF87777777777777777777788BFBFBFBF8
        7777777777777777777777788FBFBFB8777777777777777777777777788BFB87
        7777777777777777777777777778887777777777777777777777777777777777
        7777777700000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000}
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 363
    Width = 441
    Height = 28
    BiDiMode = bdRightToLeftNoAlign
    Panels = <
      item
        Alignment = taRightJustify
        BiDiMode = bdRightToLeftNoAlign
        ParentBiDiMode = False
        Width = 50
      end>
    ParentBiDiMode = False
    ParentColor = True
    ParentFont = True
    SimplePanel = False
    UseSystemFont = False
  end
  object ItemPopup: TPopupMenu
    Alignment = paRight
    Left = 80
    Top = 16
    object mnuOpen: TMenuItem
      Caption = '»«“ ﬂ‰'
      OnClick = lvDblClick
    end
    object mnuColor: TMenuItem
      Caption = '—‰ê'
      object mnuColorBlue: TMenuItem
        Caption = '«»Ì'
        OnClick = mnuColorClick
      end
      object mnuColorGreen: TMenuItem
        Caption = '”»“'
        GroupIndex = 1
        OnClick = mnuColorClick
      end
      object mnuColorPink: TMenuItem
        Caption = '’Ê— Ì'
        GroupIndex = 2
        OnClick = mnuColorClick
      end
      object mnuColorYellow: TMenuItem
        Caption = '“—œ'
        GroupIndex = 3
        OnClick = mnuColorClick
      end
      object mnuColorWhite: TMenuItem
        Caption = '”›Ìœ'
        GroupIndex = 4
        OnClick = mnuColorClick
      end
    end
    object mnuDelete: TMenuItem
      Caption = 'Õ–›'
      OnClick = mnuDeleteClick
    end
    object mnuHide: TMenuItem
      Caption = 'Å‰Â«‰'
      OnClick = mnuHideClick
    end
  end
  object ListPopup: TPopupMenu
    Left = 128
    Top = 16
    object NewNote: TMenuItem
      Caption = 'Ì«œ œ«‘  ÃœÌœ'
      OnClick = NewNoteClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object N2: TMenuItem
      Caption = ' — Ì»'
      OnClick = FormCreate
      object mnuSortNotesByText: TMenuItem
        Caption = '„ ‰'
        OnClick = mnuSortNotesByTextClick
      end
      object mnuSortNotesByColor: TMenuItem
        Caption = '—‰ê'
        OnClick = mnuSortNotesByColorClick
      end
      object mnuSortByDate: TMenuItem
        Caption = ' «—ÌŒ «ÌÃ«œ'
        OnClick = mnuSortByDateClick
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuAutoArrange: TMenuItem
      Caption = 'ŒÊœ „— »'
      OnClick = mnuAutoArrangeClick
    end
    object mnuDahsh2: TMenuItem
      Caption = '-'
    end
    object mnuSearch: TMenuItem
      Caption = 'Ã” ÃÊ'
      OnClick = mnuSearchClick
    end
    object mnuDahsh3: TMenuItem
      Caption = '-'
    end
    object mnuRestore: TMenuItem
      Caption = '‰„«Ì‘ Â„Â'
      OnClick = mnuRestoreClick
    end
  end
end
