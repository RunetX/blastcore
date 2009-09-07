object DebugForm: TDebugForm
  Left = 260
  Top = 147
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
  PixelsPerInch = 96
  TextHeight = 13
  object DebugMemo: TMemo
    Left = 0
    Top = 0
    Width = 800
    Height = 500
    Align = alClient
    Color = clWindowFrame
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object DebugPanel: TPanel
    Left = 0
    Top = 500
    Width = 800
    Height = 100
    Align = alBottom
    BevelOuter = bvLowered
    BorderStyle = bsSingle
    Color = clNone
    TabOrder = 1
    DesignSize = (
      796
      96)
    object DebugClearBtn: TButton
      Left = 704
      Top = 48
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Clear'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = DebugClearBtnClick
    end
    object DebugEdit: TEdit
      Left = 0
      Top = 0
      Width = 801
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object DebugRunCmdBtn: TButton
      Left = 608
      Top = 48
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Run'
      TabOrder = 2
    end
  end
end
