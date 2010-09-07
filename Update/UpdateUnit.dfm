object UpdateForm: TUpdateForm
  Left = 793
  Top = 59
  Width = 400
  Height = 400
  Caption = #1048#1084#1077#1102#1090#1089#1103' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 392
    Height = 332
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 332
    Width = 392
    Height = 41
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 304
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
