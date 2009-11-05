object SendMessageForm: TSendMessageForm
  Left = 386
  Top = 218
  ActiveControl = Memo1
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1077
  ClientHeight = 313
  ClientWidth = 462
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    462
    313)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TsMemo
    Left = 6
    Top = 32
    Width = 449
    Height = 273
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 30000
    ParentFont = False
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
  object Button4: TsButton
    Left = 301
    Top = 5
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
    TabOrder = 2
    OnClick = Button4Click
    SkinData.SkinSection = 'BUTTON'
  end
  object SendMesCmbBox: TComboBoxEx
    Left = 7
    Top = 7
    Width = 290
    Height = 22
    ItemsEx = <>
    Style = csExDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 16
    TabOrder = 1
    Images = MainForm.ImageList1
    DropDownCount = 8
  end
  object Button1: TsButton
    Left = 380
    Top = 5
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 3
    OnClick = Button1Click
    SkinData.SkinSection = 'BUTTON'
  end
  object ActionList1: TActionList
    Left = 368
    Top = 272
    object SendMessage: TAction
      Caption = 'SendMessage'
      SecondaryShortCuts.Strings = (
        'ctrl+enter')
      OnExecute = SendMessageExecute
    end
    object FillComboBox: TAction
      Caption = 'FillComboBox'
      OnExecute = FillComboBoxExecute
    end
  end
end
