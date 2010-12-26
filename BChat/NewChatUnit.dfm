object BChatForm: TBChatForm
  Left = 374
  Top = 142
  Width = 444
  Height = 412
  ActiveControl = BChatEdit
  Caption = 'BlastCore Chat'
  Color = clBtnFace
  Constraints.MinHeight = 115
  Constraints.MinWidth = 200
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TsStatusBar
    Left = 0
    Top = 359
    Width = 436
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = #169' 2009 '#1058#1103#1085' '#1057#1077#1084#1105#1085'. '#1042#1089#1077' '#1087#1088#1072#1074#1072' '#1085#1077' '#1079#1072#1097#1080#1097#1077#1085#1099'.'
        Width = 50
      end>
    SkinData.SkinSection = 'STATUSBAR'
  end
  object Panel1: TsPanel
    Left = 0
    Top = 0
    Width = 436
    Height = 359
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 1
    SkinData.SkinSection = 'PANEL'
    object BChatMemo: TsMemo
      Left = 1
      Top = 1
      Width = 434
      Height = 328
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
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
    object Panel2: TsPanel
      Left = 1
      Top = 329
      Width = 434
      Height = 29
      Align = alBottom
      TabOrder = 1
      SkinData.SkinSection = 'PANEL'
      DesignSize = (
        434
        29)
      object BChatEdit: TsEdit
        Left = 3
        Top = 4
        Width = 425
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 255
        ParentFont = False
        TabOrder = 0
        OnKeyDown = BChatEditKeyDown
        SkinData.SkinSection = 'EDIT'
        BoundLabel.Indent = 0
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -11
        BoundLabel.Font.Name = 'MS Sans Serif'
        BoundLabel.Font.Style = []
        BoundLabel.Layout = sclLeft
        BoundLabel.MaxWidth = 0
        BoundLabel.UseSkinColor = True
      end
      object sButton1: TsButton
        Left = 480
        Top = 8
        Width = 65
        Height = 17
        Action = Action1
        Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
        Default = True
        TabOrder = 1
        SkinData.SkinSection = 'BUTTON'
      end
    end
    object ChatBufferLB: TsListBox
      Left = 256
      Top = 8
      Width = 121
      Height = 265
      AutoCompleteDelay = 500
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
      ItemHeight = 13
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
    end
  end
  object ActionList1: TActionList
    Left = 152
    Top = 160
    object Action1: TAction
      Category = 'jjj'
      Caption = 'Action1'
      ShortCut = 13
      OnExecute = Action1Execute
    end
  end
end
