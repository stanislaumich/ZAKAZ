object DM: TDM
  OldCreateOrder = False
  Height = 473
  Width = 625
  object FDC: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'Database=D:\zakaz.sqlite')
    ConnectedStoredUsage = [auDesignTime]
    Connected = True
    LoginPrompt = False
    Left = 4
    Top = 4
  end
  object TWstud: TFDTable
    Active = True
    Connection = FDC
    TableName = 'w_stud'
    Left = 80
    Top = 36
  end
  object DWStud: TDataSource
    DataSet = TWstud
    Left = 132
    Top = 36
  end
end
