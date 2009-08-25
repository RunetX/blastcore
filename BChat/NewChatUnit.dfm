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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 304
    Width = 400
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright '#169' 2009 Peek. All rights reserved.'
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 304
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 1
    object BChatMemo: TMemo
      Left = 1
      Top = 1
      Width = 398
      Height = 273
      Align = alClient
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object Panel2: TPanel
      Left = 1
      Top = 274
      Width = 398
      Height = 29
      Align = alBottom
      TabOrder = 1
      DesignSize = (
        398
        29)
      object BChatEdit: TEdit
        Left = 3
        Top = 4
        Width = 392
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        MaxLength = 255
        TabOrder = 0
        OnKeyDown = BChatEditKeyDown
        OnKeyPress = BChatEditKeyPress
      end
    end
    object ChatBufferLB: TListBox
      Left = 256
      Top = 8
      Width = 121
      Height = 265
      ItemHeight = 13
      TabOrder = 2
      Visible = False
    end
  end
end
