object frmModel: TfrmModel
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Model Table'
  ClientHeight = 220
  ClientWidth = 471
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 471
    Height = 49
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 2
    ExplicitWidth = 397
    object edtLicense: TLabeledEdit
      Left = 56
      Top = 13
      Width = 121
      Height = 21
      Color = clBtnFace
      EditLabel.Width = 42
      EditLabel.Height = 13
      EditLabel.Caption = 'License :'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clBlue
      EditLabel.Font.Height = -11
      EditLabel.Font.Name = 'Tahoma'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      ImeMode = imDisable
      LabelPosition = lpLeft
      ReadOnly = True
      TabOrder = 2
    end
    object btnOk: TButton
      Left = 282
      Top = 9
      Width = 72
      Height = 34
      Caption = 'Ok'
      ModalResult = 1
      TabOrder = 0
    end
    object Button1: TButton
      Left = 369
      Top = 9
      Width = 72
      Height = 34
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 49
    Width = 471
    Height = 137
    Align = alClient
    DataSource = frmMain.dsModel
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Panel2: TPanel
    Left = 0
    Top = 186
    Width = 471
    Height = 34
    Align = alBottom
    Caption = 'Panel2'
    TabOrder = 1
    ExplicitWidth = 397
    object DBNavigator1: TDBNavigator
      Left = 8
      Top = 2
      Width = 450
      Height = 29
      DataSource = frmMain.dsModel
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbPost, nbCancel]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
  end
end
