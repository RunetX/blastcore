object FormSkinSelect: TFormSkinSelect
  Left = 349
  Top = 327
  Width = 500
  Height = 360
  BorderStyle = bsToolWindow
  Caption = 'Select skin'
  Color = clBtnFace
  Constraints.MinHeight = 360
  Constraints.MinWidth = 500
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sListBox1: TsListBox
    Left = 12
    Top = 48
    Width = 130
    Height = 271
    BoundLabel.Caption = 'Available skins :'
    BoundLabel.Indent = 0
    BoundLabel.Layout = sclTopLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
    ItemHeight = 13
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 0
    OnClick = sListBox1Click
    OnDblClick = sListBox1DblClick
  end
  object sBitBtn1: TsBitBtn
    Left = 308
    Top = 294
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
    SkinData.SkinSection = 'BUTTON'
  end
  object sBitBtn2: TsBitBtn
    Left = 388
    Top = 294
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    SkinData.SkinSection = 'BUTTON'
  end
  object sPanel1: TsPanel
    Left = 159
    Top = 48
    Width = 321
    Height = 231
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Caption = 'Skin preview'
    Enabled = False
    TabOrder = 3
    SkinData.SkinSection = 'CHECKBOX'
  end
  object sDirectoryEdit1: TsDirectoryEdit
    Left = 112
    Top = 12
    Width = 369
    Height = 21
    AutoSize = False
    MaxLength = 255
    TabOrder = 4
    OnChange = sDirectoryEdit1Change
    BoundLabel.Active = True
    BoundLabel.Caption = 'DIrectory with skins'
    BoundLabel.Indent = 0
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
    GlyphMode.Grayed = False
    Root = 'rfDesktop'
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'DIALOG'
    TitleButtons = <>
    Left = 448
    Top = 8
  end
end
