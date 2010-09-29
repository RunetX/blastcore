object UpdateForm: TUpdateForm
  Left = 428
  Top = 158
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
  object UpdateText: TsMemo
    Left = 0
    Top = 0
    Width = 392
    Height = 323
    Align = alClient
    TabOrder = 0
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
  end
  object sPanel1: TsPanel
    Left = 0
    Top = 323
    Width = 392
    Height = 50
    Align = alBottom
    TabOrder = 1
    SkinData.SkinSection = 'PANEL'
    object sWebLabel1: TsWebLabel
      Left = 16
      Top = 24
      Width = 135
      Height = 13
      Caption = 'http://hostel.avtf.net/sender'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      HoverFont.Charset = DEFAULT_CHARSET
      HoverFont.Color = clWindowText
      HoverFont.Height = -11
      HoverFont.Name = 'MS Sans Serif'
      HoverFont.Style = []
      URL = 'http://hostel.avtf.net/sender'
    end
    object sLabel1: TsLabel
      Left = 16
      Top = 11
      Width = 118
      Height = 13
      Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1103' '#1087#1086' '#1072#1076#1088#1077#1089#1091':'
    end
    object Button1: TButton
      Left = 303
      Top = 13
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
