object SetupForm: TSetupForm
  Left = 0
  Top = 0
  Caption = 'SetupForm'
  ClientHeight = 550
  ClientWidth = 569
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object CurvyPanel1: TCurvyPanel
    Left = 0
    Top = 0
    Width = 569
    Height = 497
    Align = alClient
    TabOrder = 0
  end
  object W7InformationBar1: TW7InformationBar
    Left = 0
    Top = 497
    Width = 569
    Height = 53
    Version = '1.0.2.0'
    object ButtonOk: TAdvGlowButton
      Left = 333
      Top = 6
      Width = 100
      Height = 41
      Caption = '&Ok'
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      TabOrder = 0
      OnClick = ButtonOkClick
      Appearance.ColorChecked = 16111818
      Appearance.ColorCheckedTo = 16367008
      Appearance.ColorDisabled = 15921906
      Appearance.ColorDisabledTo = 15921906
      Appearance.ColorDown = 16111818
      Appearance.ColorDownTo = 16367008
      Appearance.ColorHot = 16117985
      Appearance.ColorHotTo = 16372402
      Appearance.ColorMirrorHot = 16107693
      Appearance.ColorMirrorHotTo = 16775412
      Appearance.ColorMirrorDown = 16102556
      Appearance.ColorMirrorDownTo = 16768988
      Appearance.ColorMirrorChecked = 16102556
      Appearance.ColorMirrorCheckedTo = 16768988
      Appearance.ColorMirrorDisabled = 11974326
      Appearance.ColorMirrorDisabledTo = 15921906
    end
    object ButtonCancel: TAdvGlowButton
      Left = 466
      Top = 6
      Width = 100
      Height = 41
      Caption = '&Avbryt'
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      TabOrder = 1
      OnClick = ButtonCancelClick
      Appearance.ColorChecked = 16111818
      Appearance.ColorCheckedTo = 16367008
      Appearance.ColorDisabled = 15921906
      Appearance.ColorDisabledTo = 15921906
      Appearance.ColorDown = 16111818
      Appearance.ColorDownTo = 16367008
      Appearance.ColorHot = 16117985
      Appearance.ColorHotTo = 16372402
      Appearance.ColorMirrorHot = 16107693
      Appearance.ColorMirrorHotTo = 16775412
      Appearance.ColorMirrorDown = 16102556
      Appearance.ColorMirrorDownTo = 16768988
      Appearance.ColorMirrorChecked = 16102556
      Appearance.ColorMirrorCheckedTo = 16768988
      Appearance.ColorMirrorDisabled = 11974326
      Appearance.ColorMirrorDisabledTo = 15921906
    end
  end
  object FYSPAF_setup: TSQLConnection
    ConnectionName = 'STGFYS-SGPD0013\NSSQLSERV'
    DriverName = 'MSSQL'
    LoginPrompt = False
    Params.Strings = (
      'drivername=MSSQL'
      'schemaoverride=%.dbo'
      'vendorlibwin64=sqlncli10.dll'
      'HostName=STGFYS-SGPD0013\NSSQLSERV'
      'database=fyspaf3'
      'user_name=pa'
      'password=purkebas'
      'blobsize=-1'
      'localecode=0000'
      'isolationlevel=ReadCommitted'
      'os authentication=False'
      'prepare sql=False')
    Left = 106
    Top = 432
  end
  object DTB_GetTidbokTyp: TSQLDataSet
    SchemaName = 'dbo'
    CommandText = 'DTB_GetTidbokTyp'
    CommandType = ctStoredProc
    DbxCommandType = 'Dbx.StoredProcedure'
    MaxBlobSize = -1
    ParamCheck = False
    Params = <
      item
        DataType = ftInteger
        Name = '@Typ'
        ParamType = ptInput
        Value = '1'
      end>
    SQLConnection = FYSPAF_setup
    Left = 23
    Top = 408
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 312
    Top = 376
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = DTB_GetTidbokTyp
    Left = 85
    Top = 352
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 194
    Top = 368
  end
  object PafConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=PAF')
    LoginPrompt = False
    Left = 392
    Top = 82
  end
end
