object BChatForm: TBChatForm
  Left = 190
  Top = 144
  Width = 408
  Height = 357
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
    Top = 311
    Width = 400
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright '#169' 2009 Peek. All rights reserved.'
        Width = 50
      end>
    SkinData.SkinSection = 'STATUSBAR'
  end
  object Panel1: TsPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 311
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 1
    SkinData.SkinSection = 'PANEL'
    object BChatMemo: TsMemo
      Left = 1
      Top = 1
      Width = 398
      Height = 280
      Align = alClient
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
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
      Top = 281
      Width = 398
      Height = 29
      Align = alBottom
      TabOrder = 1
      SkinData.SkinSection = 'PANEL'
      DesignSize = (
        398
        29)
      object BChatEdit: TsEdit
        Left = 3
        Top = 4
        Width = 392
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clLime
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 255
        ParentFont = False
        TabOrder = 0
        OnKeyDown = BChatEditKeyDown
        OnKeyPress = BChatEditKeyPress
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
end
