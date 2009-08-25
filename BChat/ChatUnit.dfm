object ChatForm: TChatForm
  Left = 300
  Top = 180
  BorderStyle = bsDialog
  Caption = 'ChatForm'
  ClientHeight = 360
  ClientWidth = 433
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    433
    360)
  PixelsPerInch = 96
  TextHeight = 13
  object ChatEdit: TEdit
    Left = 0
    Top = 336
    Width = 433
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    MaxLength = 200
    TabOrder = 0
  end
  object ChatMemo: TMemo
    Left = 0
    Top = 0
    Width = 433
    Height = 329
    Align = alCustom
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    TabOrder = 1
  end
end
