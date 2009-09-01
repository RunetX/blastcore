object SentMesForm: TSentMesForm
  Left = 192
  Top = 107
  Width = 548
  Height = 377
  Caption = #1054#1090#1086#1089#1083#1072#1085#1085#1099#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
  Color = clBtnFace
  Constraints.MinHeight = 350
  Constraints.MinWidth = 540
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TsPanel
    Left = 0
    Top = 0
    Width = 540
    Height = 350
    Align = alClient
    BorderStyle = bsSingle
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    DesignSize = (
      536
      346)
    object SentMesLV: TsListView
      Left = 1
      Top = 1
      Width = 534
      Height = 309
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
      Align = alCustom
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = clBlack
      Columns = <
        item
          Caption = #1044#1072#1090#1072
          Width = 70
        end
        item
          Caption = #1042#1088#1077#1084#1103
          Width = 60
        end
        item
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
          Width = 130
        end
        item
          Caption = #1050#1086#1084#1087#1100#1102#1090#1077#1088
          Width = 130
        end
        item
          AutoSize = True
          Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ReadOnly = True
      RowSelect = True
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = ReSendExecute
    end
    object Button1: TsButton
      Left = 296
      Top = 317
      Width = 75
      Height = 25
      Action = ReSend
      Anchors = [akRight, akBottom]
      TabOrder = 1
      SkinData.SkinSection = 'BUTTON'
    end
    object Button2: TsButton
      Left = 376
      Top = 317
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 2
      OnClick = Button2Click
      SkinData.SkinSection = 'BUTTON'
    end
    object Button3: TsButton
      Left = 456
      Top = 317
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 3
      OnClick = Button3Click
      SkinData.SkinSection = 'BUTTON'
    end
  end
  object ActionList1: TActionList
    Left = 240
    Top = 320
    object ReSend: TAction
      Caption = #1055#1077#1088#1077#1089#1083#1072#1090#1100
      ShortCut = 16466
      OnExecute = ReSendExecute
    end
  end
end
