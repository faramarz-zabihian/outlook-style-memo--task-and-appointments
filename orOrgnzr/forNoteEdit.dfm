object frmEditNote: TfrmEditNote
  Left = 296
  Top = 164
  Width = 246
  Height = 226
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Anchors = [akTop]
  BiDiMode = bdRightToLeftReadingOnly
  BorderIcons = [biSystemMenu]
  Color = clWindow
  Ctl3D = False
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFF079F900FFFFFFFFFFFFFFFFFFFF
    FFFF079F9F9700FFFFFFFFFFFFFFFFFFFFF089F9F9F9F900FFFFFFFFFFFFFFFF
    FFF09F9F9F9F9F9700FFFFFFFFFFFFFFFF09F9F9F9F9F9F9F900FFFFFFFFFFFF
    FF0F9F98979F9F9F9F9700FFFFFFFFFFF079F979897979F9F9F9F900FFFFFFFF
    F09F9F979797979F9F9F9F9700FFFFFF09F9F9F9F97979F979F9F9F9F900FFFF
    0F9F979F9F979F98979F9F9F9F98FFF079F9F98979F9F979F989F9F9F978FFF0
    9F9F989897979F979797979F978FFF09F9F9F979798979F97989897978FFFF0F
    9F989F9F9897989F9F9F979F98FFF079F9797979F9F9798979F979F98FFFF09F
    9F9898979F9F9F97989F9F978FFF09F9F9F979798979F9797979F978FFFF079F
    9F9F9F9898979F9F979F9F98FFFFF88979F9F97979F979F9F9F9F98FFFFFFFF8
    879F9F9F9F9F9897979F978FFFFFFFFFF88979F9F9F9797979F978FFFFFFFFFF
    FFF8879F9F9F9F979F9F98FFFFFFFFFFFFFFF88979F9F9F9F9F98FFFFFFFFFFF
    FFFFFFF8879F9F9F9F978FFFFFFFFFFFFFFFFFFFF88979F9F978FFFFFFFFFFFF
    FFFFFFFFFFF8879F9F98FFFFFFFFFFFFFFFFFFFFFFFFF889798FFFFFFFFFFFFF
    FFFFFFFFFFFFFFF888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  KeyPreview = True
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object reMemo: TRichEdit
    Left = 0
    Top = 0
    Width = 238
    Height = 180
    Align = alClient
    Alignment = taRightJustify
    BiDiMode = bdRightToLeftNoAlign
    BorderStyle = bsNone
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'reMemo')
    ParentBiDiMode = False
    ParentColor = True
    ParentCtl3D = False
    ParentFont = False
    PopupMenu = mnuSys
    TabOrder = 0
    OnChange = reMemoChange
  end
  object sbStatus: TStatusBar
    Left = 0
    Top = 180
    Width = 238
    Height = 19
    BiDiMode = bdRightToLeftNoAlign
    Color = clMenu
    Panels = <
      item
        Alignment = taRightJustify
        Bevel = pbNone
        Text = 'Current Date'
        Width = 50
      end>
    ParentBiDiMode = False
    SimplePanel = False
  end
  object mnuSys: TPopupMenu
    Left = 144
    Top = 64
    object mnuCut: TMenuItem
      Action = EditCut
      Caption = '»»—'
    end
    object mnuCopy: TMenuItem
      Action = EditCopy
      Caption = '»—œ«—'
    end
    object mnuPaste: TMenuItem
      Action = EditPaste
      Caption = '»ê–«—'
    end
    object mnuDash: TMenuItem
      Caption = '-'
    end
    object mnuPrint: TMenuItem
      Caption = 'ç«Å'
      OnClick = mnuPrintClick
    end
    object mnuSaveAs: TMenuItem
      Caption = 'À»  ﬂ‰ »Â «”„'
      OnClick = mnuSaveAsClick
    end
    object mnuClose: TMenuItem
      Caption = '»»‰œ'
      OnClick = mnuCloseClick
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'rtf'
    Filter = '*.rtf|*.*'
    Left = 104
    Top = 64
  end
  object PrintDialog: TPrintDialog
    Left = 200
    Top = 64
  end
  object ActionList1: TActionList
    OnUpdate = ActionList1Update
    Left = 32
    Top = 64
    object EditCut: TEditCut
      Category = 'Edit'
      Caption = 'Cu&t'
      Hint = 'Cut'
      ImageIndex = 0
      ShortCut = 16472
    end
    object EditCopy: TEditCopy
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy'
      ImageIndex = 1
      ShortCut = 16451
    end
    object EditPaste: TEditPaste
      Category = 'Edit'
      Caption = '&Paste'
      Hint = 'Paste'
      ImageIndex = 2
      ShortCut = 16470
    end
  end
end
