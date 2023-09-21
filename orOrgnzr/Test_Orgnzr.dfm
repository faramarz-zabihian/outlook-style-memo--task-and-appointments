object frm_Test: Tfrm_Test
  Left = 21
  Top = 249
  BorderStyle = bsSingle
  Caption = 'Tasks'
  ClientHeight = 222
  ClientWidth = 409
  Color = clWindow
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 409
    Height = 41
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 290
      Top = 5
      Width = 56
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'ﬂ«—Â«'
      TabOrder = 0
      OnClick = Button1Click
    end
    object btnCalendar: TButton
      Left = 351
      Top = 5
      Width = 56
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'ﬁ—«—Â«'
      TabOrder = 1
      OnClick = btnCalendarClick
    end
    object Notes: TButton
      Left = 229
      Top = 5
      Width = 56
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'Ì«œœ«‘ '
      TabOrder = 2
      OnClick = NotesClick
    end
    object Events: TButton
      Left = 10
      Top = 5
      Width = 56
      Height = 27
      Caption = ' ﬁÊÌ„ ⁄„Ê„Ì'
      TabOrder = 3
      OnClick = EventsClick
    end
    object Configure: TButton
      Left = 71
      Top = 5
      Width = 56
      Height = 27
      Caption = ' ‰ŸÌ„ ”«⁄«  '
      TabOrder = 4
      OnClick = ConfigureClick
    end
  end
end
