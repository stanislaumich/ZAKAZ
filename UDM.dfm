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
  object DFind: TDataSource
    DataSet = QFind
    Left = 132
    Top = 92
  end
  object QFind: TFDQuery
    Active = True
    Connection = FDC
    SQL.Strings = (
      'select * '
      'from w_stud '
      'where fam like :fam '
      'and name like :name '
      'and otch like :otch ')
    Left = 80
    Top = 92
    ParamData = <
      item
        Name = 'FAM'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'NAME'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'OTCH'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
