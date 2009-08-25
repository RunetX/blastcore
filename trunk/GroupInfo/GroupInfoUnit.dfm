object GroupInfoForm: TGroupInfoForm
  Left = 148
  Top = 62
  Width = 696
  Height = 480
  BorderStyle = bsSizeToolWin
  Caption = #1055#1086#1083#1091#1095#1077#1085#1080#1077' '#1050#1086#1084#1087#1083#1077#1082#1089#1085#1086#1081' '#1048#1085#1092#1086#1088#1084#1072#1094#1080#1080' '#1086' '#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103#1093
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  DesignSize = (
    688
    453)
  PixelsPerInch = 96
  TextHeight = 13
  object GrInfoListView: TListView
    Left = 8
    Top = 8
    Width = 673
    Height = 409
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
        Width = 100
      end
      item
        Caption = #1050#1086#1084#1087#1100#1102#1090#1077#1088
        Width = 130
      end
      item
        Caption = #1060#1072#1082#1091#1083#1100#1090#1077#1090
      end
      item
        Caption = #1050#1086#1084#1085#1072#1090#1072
        Width = 40
      end
      item
        Caption = #1050#1088#1072#1090#1082#1072#1103' '#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
        Width = 160
      end
      item
        Caption = #1042#1077#1088#1089#1080#1103
        Width = 40
      end
      item
        Caption = 'IP-'#1072#1076#1088#1077#1089
        Width = 140
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object GetGIBtn: TButton
    Left = 488
    Top = 424
    Width = 91
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1057#1076#1077#1083#1072#1090#1100' '#1047#1072#1087#1088#1086#1089
    TabOrder = 1
    OnClick = GetGIBtnClick
  end
  object ClrGIBtn: TButton
    Left = 592
    Top = 424
    Width = 81
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 2
    OnClick = ClrGIBtnClick
  end
  object DelayTimer: TTimer
    Tag = 2
    Enabled = False
    Interval = 1
    OnTimer = DelayTimerTimer
    Left = 48
    Top = 424
  end
end
