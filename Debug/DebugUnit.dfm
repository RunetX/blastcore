object DebugForm: TDebugForm
  Left = 249
  Top = 167
  Width = 808
  Height = 634
  Caption = 'DebugForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DebugMemo: TsMemo
    Left = 0
    Top = 0
    Width = 800
    Height = 560
    Align = alClient
    Color = clWindowText
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
  object DebugPanel: TsPanel
    Left = 0
    Top = 560
    Width = 800
    Height = 47
    Align = alBottom
    BorderStyle = bsSingle
    TabOrder = 1
    SkinData.SkinSection = 'PANEL'
    DesignSize = (
      796
      43)
    object DebugClearBtn: TsButton
      Left = 712
      Top = 11
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Clear'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = DebugClearBtnClick
      SkinData.SkinSection = 'BUTTON'
    end
    object DebugEdit: TsEdit
      Left = 8
      Top = 8
      Width = 361
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      Visible = False
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
    object DebugRunCmdBtn: TsButton
      Left = 376
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Run'
      TabOrder = 2
      Visible = False
      SkinData.SkinSection = 'BUTTON'
    end
    object DebugSaveToFileBtn: TsButton
      Left = 624
      Top = 11
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Save to file'
      TabOrder = 3
      OnClick = DebugSaveToFileBtnClick
      SkinData.SkinSection = 'BUTTON'
    end
  end
  object SaveDebugInfo: TsSaveDialog
    Left = 592
    Top = 571
  end
end
