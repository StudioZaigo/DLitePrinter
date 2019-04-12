object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'DLitePrinter'
  ClientHeight = 147
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblAbout: TLabel
    Left = 222
    Top = 129
    Width = 227
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'lblAbout'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object edtFileName: TLabeledEdit
    Left = 72
    Top = 14
    Width = 300
    Height = 21
    EditLabel.Width = 52
    EditLabel.Height = 13
    EditLabel.Caption = '&File name :'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clBlue
    EditLabel.Font.Height = -11
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    ImeMode = imDisable
    LabelPosition = lpLeft
    TabOrder = 0
    OnChange = edtFileNameChange
  end
  object btnFind: TButton
    Left = 378
    Top = 8
    Width = 71
    Height = 33
    Action = actRefer
    Default = True
    TabOrder = 1
  end
  object btnModel: TButton
    Left = 378
    Top = 90
    Width = 71
    Height = 33
    Action = actShowModel
    Caption = '&Show Model'
    TabOrder = 2
  end
  object btnBrowse: TButton
    Left = 378
    Top = 51
    Width = 71
    Height = 33
    Action = actBrowse
    TabOrder = 3
  end
  object edtApplication: TLabeledEdit
    Left = 72
    Top = 41
    Width = 217
    Height = 21
    Color = clBtnFace
    EditLabel.Width = 59
    EditLabel.Height = 13
    EditLabel.Caption = 'Application :'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clBlue
    EditLabel.Font.Height = -11
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    ImeMode = imDisable
    LabelPosition = lpLeft
    ReadOnly = True
    TabOrder = 4
    Text = #22793#26356#30003#35531#26360
  end
  object edtLicense: TLabeledEdit
    Left = 72
    Top = 68
    Width = 217
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
    TabOrder = 5
    Text = #22793#26356#30003#35531#26360
  end
  object edtCallsign: TLabeledEdit
    Left = 72
    Top = 95
    Width = 217
    Height = 21
    Color = clBtnFace
    EditLabel.Width = 43
    EditLabel.Height = 13
    EditLabel.Caption = 'Callsign :'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clBlue
    EditLabel.Font.Height = -11
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    ImeMode = imDisable
    LabelPosition = lpLeft
    ReadOnly = True
    TabOrder = 6
    Text = #22793#26356#30003#35531#26360
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'zip'
    Filter = 'shinsei file(Zip)|*.zip|shinsei file(XML)|*.xml'
    Options = [ofEnableSizing]
    Title = 'Select file'
    Left = 344
    Top = 104
  end
  object PopupMenu1: TPopupMenu
    Left = 272
    Top = 104
    object mnuExit: TMenuItem
      Action = actExit
    end
    object mnuBar1: TMenuItem
      Caption = '-'
    end
    object mnuRefer: TMenuItem
      Action = actRefer
    end
    object mnuOpen: TMenuItem
      Action = actBrowse
    end
    object mnuShowModel: TMenuItem
      Action = actShowModel
    end
  end
  object ActionManager1: TActionManager
    Left = 224
    Top = 104
    StyleName = 'Platform Default'
    object actRefer: TAction
      Caption = '&Refer'
      ShortCut = 16466
      OnExecute = actReferExecute
    end
    object actBrowse: TAction
      Caption = '&Browse'
      ShortCut = 16463
      OnExecute = actBrowseExecute
    end
    object actShowModel: TAction
      Caption = '&Show Model table'
      ShortCut = 16467
      OnExecute = actShowModelExecute
    end
    object actExit: TAction
      Caption = 'Exit'
      ShortCut = 16472
    end
  end
  object cdsModel: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 240
    Top = 48
  end
  object dsModel: TDataSource
    DataSet = cdsModel
    Left = 320
    Top = 48
  end
end
