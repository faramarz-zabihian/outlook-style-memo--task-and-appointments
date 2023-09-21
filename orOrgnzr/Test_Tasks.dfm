object frm_Test: Tfrm_Test
  Left = 20
  Top = 139
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Tasks'
  ClientHeight = 222
  ClientWidth = 116
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
  object Button1: TButton
    Left = 28
    Top = 74
    Width = 56
    Height = 60
    Caption = 'Tasks'
    TabOrder = 0
    OnClick = Button1Click
  end
  object btnCalendar: TButton
    Left = 29
    Top = 154
    Width = 56
    Height = 60
    Caption = 'Calendar'
    TabOrder = 1
    OnClick = btnCalendarClick
  end
  object Button2: TButton
    Left = 29
    Top = 6
    Width = 56
    Height = 60
    Caption = 'Notes'
    TabOrder = 2
    OnClick = Button2Click
  end
end
